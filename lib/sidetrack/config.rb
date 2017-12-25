module Sidetrack
  class Config
    include Singleton
    attr_writer :track_actors

    def track_actors?
      @track_actors || false
    end

  end
end
