require "test_helper"

class UserAnswerTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
    @game = games(:game_one)
  end

  test "Prevent user sending same answer multiple time" do
    player = users(:user_one)
    choices = Question.find(@game.current_question_id).choices

    @game.user_answers.create!(
      user: player,
      choice: choices.first,
      question_id: @game.current_question_id
    )

    assert_raise ActiveRecord::RecordInvalid do
      @game.user_answers.create!(
        user: player,
        choice: choices.last,
        question_id: @game.current_question_id
      )
    end
  end
end
