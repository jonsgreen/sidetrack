class Grain < ApplicationRecord
  sidetrack :sown, :weeded, track_actor: true
end
