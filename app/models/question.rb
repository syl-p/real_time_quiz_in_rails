class Question < ApplicationRecord
  belongs_to :quiz
  has_many :choices

  validates_presence_of :content
  validate :presence_of_correct_choice

  private
  def presence_of_correct_choice
    all_choices = choices.to_a

    unless all_choices.any?(&:correct)
      errors.add(:choices, "doit avoir au moins une réponse correcte")
    end
  end
end
