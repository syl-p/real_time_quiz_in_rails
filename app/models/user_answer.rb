class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :choice
  belongs_to :game
end
