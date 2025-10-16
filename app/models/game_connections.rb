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
