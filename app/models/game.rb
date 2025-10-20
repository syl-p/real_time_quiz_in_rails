class Game < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :user_answers

  after_touch :check_answers

  def user_in_this_game
    GameConnections.list(id)
  end

  def all_players_answered?(question_id)
    users_with_answer = user_answers.joins(:choice)
                                    .where(choices: { question_id: question_id })
                                    .distinct
                                    .count
    users_in_connections = GameConnections.list(id).count

    users_in_connections == users_with_answer
  end

  def current_question_id
    Rails.cache.fetch("game:#{id}:current_question_id", expires_in: 1.hour) do
      quiz.questions.first.id
    end
  end

  def set_next_question
    next_question = quiz.questions.where("id > ?", current_question_id).first

    if next_question.present?
      Rails.cache.write("game:#{id}:current_question_id", next_question.id)
      broadcast_question(next_question)
    else
      finish_game
    end
  end

  private
  def broadcast_question(question)
    broadcast_replace_to "game_#{id}_current_question",
                         target: "current_question",
                         partial: "games/user_answers/form",
                         locals: { user_answers: UserAnswer.new, game_id: id, question: question }
  end

  def finish_game
    broadcast_replace_to "game_#{id}_current_question",
                         target: "current_question",
                         partial: "games/finished"
  end

  def check_answers
    if all_players_answered?(current_question_id)
      set_next_question
    end
  end
end
