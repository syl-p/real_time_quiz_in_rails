class Choice < ApplicationRecord
  attribute :correct, :boolean, default: false
  belongs_to :question
end
