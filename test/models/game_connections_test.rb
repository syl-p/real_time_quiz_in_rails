require "test_helper"

class GameConnectionsTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
    @game = games(:game_one)
  end

  test "Should persist user connection in cache" do
    user = @game.user

    user_object_to_store = { id: user.id, username: user.username }
    GameConnections.add(@game.id, user_object_to_store)
    user_list =  GameConnections.list(@game.id)

    assert_includes user_list, user_object_to_store
  end

  test "User must be added to cache once" do
    user = @game.user

    user_object_to_store = { id: user.id, username: user.username }
    GameConnections.add(@game.id, user_object_to_store)
    GameConnections.add(@game.id, user_object_to_store)

    assert_equal 1, GameConnections.list(@game.id).count
  end
end
