class Games::UserAnswersController < ApplicationController
  before_action :set_game, only: [ :new, :create ]
  before_action :set_question, only: [ :new, :create ]

  def new
  end

  def create
    answer = UserAnswer.new(user_answer_params)
    answer.game = @game
    answer.question = @question
    answer.user = Current.user

    if answer.save
      flash[:success] = "Réponse enregistrée"
    else
      flash[:alert] = "Something went wrong"
    end

    # @game.reload
    # redirect_to game_new_user_answer_path(game_id: @game.id, question_id: @game.current_question_id)
  end

  private
  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def user_answer_params
    params.expect(user_answer: [ :choice_id ])
  end
end
