class Games::UserAnswersController < ApplicationController
  def create
    answer = new UserAnswer.create
    answer.game = @game
    answer.question = @question
    if answer.save

    end
  end

  private
  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def user_answer_params

  end
end
