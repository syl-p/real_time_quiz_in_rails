class Games::UserAnswersController < ApplicationController
  before_action :set_game, only: [ :new, :create ]
  before_action :set_question, only: [ :new, :create ]

  def new
    @user_answer = UserAnswer.new
  end

  def create
    @user_answer = UserAnswer.new(user_answer_params)
    @user_answer.game = @game
    @user_answer.user = Current.user

    if @user_answer.save
      flash[:success] = "Réponse enregistrée"
      head :ok
    else
      render :new, status: :unprocessable_entity
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
    params.fetch(:user_answer, {}).permit(:choice_id)
  end
end
