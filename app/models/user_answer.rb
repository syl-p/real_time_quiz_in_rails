class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :choice
  belongs_to :game, touch: true
  has_one :question, through: :choice
end
