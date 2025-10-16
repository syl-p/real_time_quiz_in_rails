class GameChannel < ApplicationCable::Channel
  extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods
  include ActionView::RecordIdentifier

  def subscribed
    Rails.logger.info ">>> Attempt to connect with game with id: #{params[:id]}"

    @game_id = params[:id]
    @game = Game.find(params[:id])

    stream_from "game_#{@game.id}"
    GameConnections.add(@game.id, current_user)

    Rails.logger.info ">>> Subscribed to game #{@game.id}"

    broadcast_join current_user
    transmit render_user_list(GameConnections.list(@game.id))
  end

  def unsubscribed
    broadcast_leave current_user
  end


  private

  def broadcast_join(user)
    Rails.logger.info ">>> broadcasting append for #{@game.id} and user #{user}"
    Turbo::StreamsChannel.broadcast_append_to(
      "game_#{@game.id}",
      target: "users-list",
      partial: "games/user",
      locals: { user: user }
    )
  end

  def broadcast_leave(user)
    Turbo::StreamsChannel.broadcast_remove_to(
      "game_#{@game.id}",
      target: dom_id(user)
    )
  end

  def render_user_list(users)
    ApplicationController.render(
      partial: "games/users_list",
      locals: { users: users }
    )
  end
end
