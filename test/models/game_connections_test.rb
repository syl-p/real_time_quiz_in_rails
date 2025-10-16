require "test_helper"

class GameConnectionsTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test "Should persist user connection in cache" do
    game = games(:game_one)
    user = game.user

    user_object_to_store = { id: user.id, username: user.username }
    GameConnections.add(game.id, user_object_to_store)
    user_list =  GameConnections.list(game.id)

    assert_includes user_list, user_object_to_store
  end
end
