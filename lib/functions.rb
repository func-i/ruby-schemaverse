class Functions
  class << self

    # Returns the id for the given player name
    # @param [String] player_name The name of the player
    # @return [String] The player's id
    def get_player_id(player_name)      
      ActiveRecord::Base.connection.execute("SELECT GET_PLAYER_ID(#{player_name}) as player_id").first["player_id"]
    end

    # Returns the username for the given player id
    # @param [String] player_id The id of the player
    # @return [String] The player's username
    def get_player_username(player_id)
      ActiveRecord::Base.connection.execute("SELECT GET_PLAYER_USERNAME(#{player_id}) as player_username").first["player_username"]
    end

    # An important method that will allow you to get Schemaverse variables
    # @param [String] var Can be: `MAX_SHIP_SKILL` or `MAX_SHIP_FUEL` or `MAX_SHIP_SPEED` and many others
    # @return [String]
    def get_numeric_variable(var)
      ActiveRecord::Base.connection.execute("SELECT GET_NUMERIC_VARIABLE('#{var}') as numeric_variable").first["numeric_variable"].to_f
    end
    
  end

end