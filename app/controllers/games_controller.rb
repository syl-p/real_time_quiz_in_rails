class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = Game.all
  end

  def show
    @game.current_question = @game.quiz.questions.first
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end
end
