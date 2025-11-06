class GameChannel < ApplicationCable::Channel
  extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods
  include ActionView::RecordIdentifier

  def subscribed
    # Rails.logger.info ">>> Attempt to connect with game with id: #{params[:id]}"

    @game_id = params[:id]
    @game = Game.find(params[:id])

    stream_from "game_#{@game.id}"
    GameConnections.add(@game.id, current_user)

    # Rails.logger.info ">>> Subscribed to game #{@game.id}"

    broadcast_join current_user

    # TODO: DO IT BETTER
    GameConnections.list(@game.id).each do |user|
      broadcast_join user
    end
  end

  def unsubscribed
    GameConnections.remove(@game.id, current_user)
    broadcast_leave current_user
  end


  private

  def broadcast_join(user)
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
end
