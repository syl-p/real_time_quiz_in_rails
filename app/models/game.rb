class Game < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :user_answers
  delegate :current_question_id, to: :game_service
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

  private
  def game_service
    @service ||= GameService.new(self)
  end

  def check_answers
    game_service.check_game_state!
  end
end
