=begin
class GameConnections
  @connections = Hash.new { |h, k| h[k] = Set.new }
  class << self
    def add(game_id, user_id)
      @connections[game_id] << user_id
    end

    def remove(game_id, user_id)
      @connections[game_id].delete(user_id)
    end

    def list(game_id)
      @connections[game_id]
    end
  end
end
=end
class GameConnections
  def self.add(game_id, user)
    users_list = Rails.cache.fetch("game:#{game_id}:users") { [] }
    users_list << user
    users_list.uniq!
    Rails.cache.write("game:#{game_id}:users", users_list)
  end

  def self.remove(game_id, user)
    users_list = Rails.cache.fetch("game:#{game_id}:users") { [] }
    users_list.delete(user)
    Rails.cache.write("game:#{game_id}:users", users_list)
  end

  def self.list(game_id)
    Rails.cache.fetch("game:#{game_id}:users") { [] }
  end

  def self.clear(game_id)
    Rails.cache.delete("game:#{game_id}:users")
  end
end
