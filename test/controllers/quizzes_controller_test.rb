require "test_helper"

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @quiz = quizzes(:quiz_one)
    sign_in(@user)
  end

  test "quiz show page response 200" do
    get quiz_path(id: @quiz.id)
    assert_response :success
  end
end
