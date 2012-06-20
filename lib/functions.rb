class Functions
  class << self

    # Returns the id for the given player name   
    def get_player_id(player_name)      
      ActiveRecord::Base.connection.execute("SELECT GET_PLAYER_ID(#{player_name}) as player_id").first["player_id"]
    end

    # Returns the username for the given player id
    def get_player_username(player_id)
      ActiveRecord::Base.connection.execute("SELECT GET_PLAYER_USERNAME(#{player_id}) as player_username").first["player_username"]
    end
    
  end

end