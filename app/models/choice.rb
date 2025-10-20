class Choice < ApplicationRecord
  attribute :correct, :boolean, default: false
  belongs_to :question

  validates_presence_of :label
end
