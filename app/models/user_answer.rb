class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :choice
  belongs_to :game, touch: true
  belongs_to :question

  validates_presence_of :choice, :game, :user
  validates :user_id, uniqueness: { scope: [ :question_id, :game_id ],
                                    message: "a déjà répondu à cette question" }
end
