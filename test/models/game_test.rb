require "test_helper"

class GameTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
    @game = games(:game_one)
  end

  test "At the start game have a current question" do
    assert_not_nil @game.current_question_id

    first_question_in_relation = @game.quiz.questions.first
    assert_equal @game.current_question_id, first_question_in_relation.id
  end

  test "Answer can be added to the game" do
    player = users(:user_one)
    choices = Question.find(@game.current_question_id).choices

    assert_difference "@game.user_answers.count", 1 do
      @game.user_answers.create!(
        user: player,
        choice: choices.first,
        question_id: @game.current_question_id
      )
    end
  end

  test "Game was touched when answer is added" do
    player = users(:user_one)
    choices = @game.quiz.questions.find(@game.current_question_id).choices
    updated_at_before = @game.updated_at

    @game.user_answers.create!(
      user: player,
      choice: choices.first,
      question_id: @game.current_question_id
    )

    assert_not_equal @game.updated_at, updated_at_before
  end

  test "Check method all_players_answered" do
    user_one = users(:user_one)
    user_two = users(:user_two)
    GameConnections.add(@game.id, user_one)
    GameConnections.add(@game.id, user_two)

    current_question_id_before = @game.current_question_id

    @game.user_answers.create!(
      user: user_one,
      choice: choices.first,
      question_id: @game.current_question_id
    )

    assert_not @game.all_players_answered?(current_question_id_before)

    @game.user_answers.create!(
      user: user_two,
      choice: choices.first,
      question_id: @game.current_question_id
    )

    assert @game.all_players_answered?(current_question_id_before)
  end
end
