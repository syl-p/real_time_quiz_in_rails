class GameService
  def initialize(game)
    @game = game
  end

  def current_question_id
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      @game.quiz.questions.first.id
    end
  end

  def next_question
    current_id = Rails.cache.read(cache_key)
    @game.quiz.questions.where("id > ?", current_id).first
  end

  def set_next_question!
    n_question = next_question

    if n_question.present?
      Rails.cache.write(cache_key, n_question.id)
      broadcast_question(n_question)
    else
      finish_game
    end
  end

  def check_game_state!
    if @game.all_players_answered?(current_question_id)
      set_next_question!
    end
  end

  private
  def cache_key
    "game:#{@game.id}:current_question_id"
  end

  def broadcast_question(question)
    # RESET USER LIST
    Turbo::StreamsChannel.broadcast_replace_to "game_#{@game.id}",
                                               target: "users-list",
                                               partial: "games/users_list",
                                               locals: { users: @game.user_in_this_game }


    # CHANGE QUESTION
    Turbo::StreamsChannel.broadcast_replace_to "game_#{@game.id}_current_question",
                         target: "current_question",
                         partial: "games/user_answers/form",
                         locals: { user_answer: UserAnswer.new, game_id: @game.id, question: question }
  end

  def finish_game
    Turbo::StreamsChannel.broadcast_replace_to "game_#{@game.id}_current_question",
                         target: "current_question",
                         partial: "games/finished"
  end
end
