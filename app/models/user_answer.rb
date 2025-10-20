class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :choice
  belongs_to :game, touch: true
  has_one :question, through: :choice

  validates_presence_of :choice, :game, :user
  validates :user_id, uniqueness: { scope: [ :choice_id, :game_id ],
                                    message: "a déjà répondu à cette question" }
end
