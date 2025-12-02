class GameConnections

  # @param [Integer] game_id
  # @param [User] user
  def self.add(game_id, user)
    users_list = Rails.cache.fetch("game:#{game_id}:users") { [] }
    users_list << user
    users_list.uniq!
    Rails.cache.write("game:#{game_id}:users", users_list)
  end


  # @param [Integer] game_id
  # @param [User] user
  def self.remove(game_id, user)
    users_list = Rails.cache.fetch("game:#{game_id}:users") { [] }
    users_list.delete(user)
    Rails.cache.write("game:#{game_id}:users", users_list)
  end


  # @param [Integer] game_id
  def self.list(game_id)
    Rails.cache.fetch("game:#{game_id}:users") { [] }
  end


  # @param [Integer] game_id
  def self.clear(game_id)
    Rails.cache.delete("game:#{game_id}:users")
  end
end
