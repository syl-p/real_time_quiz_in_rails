require "test_helper"

class QuizTest < ActiveSupport::TestCase
  setup do
    @quiz = quizzes(:quiz_one)
  end

  test "quiz has its questions and choices" do
    assert_not_empty @quiz.questions
    assert_not_empty @quiz.questions.first.choices
  end
end
