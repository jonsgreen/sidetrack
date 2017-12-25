module Sidetrack
  class Tracking < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true
    belongs_to :actorable, polymorphic: true,
      optional: true if Sidetrack.config.track_actors?
  end
end
