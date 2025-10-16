class Game < ApplicationRecord
  attr_accessor :current_question
  belongs_to :quiz
  belongs_to :user
  has_many :user_answers

  def user_in_this_game
    GameConnections.list(id)
  end

  def all_players_answered?(question)
    users_with_answer = user_answers.where(question: question).pluck(:user_id)
    users_with_answer.count == users_with_answer.uniq.count
  end
end
