class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :choice
  belongs_to :game, touch: true
  belongs_to :question

  validates_presence_of :choice, :game, :user
  validates :user_id, uniqueness: { scope: [ :question_id, :game_id ],
                                    message: "a déjà répondu à cette question" }

  after_create :update_presence_with_response!

  private
  def update_presence_with_response!
    broadcast_replace_to "game_#{game_id}",
                         target: "user_#{user.id}",
                         partial: "games/user",
                         locals: { user: user, answer: true }
  end
end
