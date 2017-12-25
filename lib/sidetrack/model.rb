module Sidetrack
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def sidetrack(*tracked_fields, track_history: false, track_actor: false)
        self.has_many :trackings, as: :trackable, class_name: 'Sidetrack::Tracking'

        tracked_fields.each do |field|
          Sidetrack::Tracking.scope field, -> { where(event: field) }

          if track_history
            define_method("#{field}!") do |happened_at=Time.now, actor: nil|
              attrs = { event: field, happened_at: happened_at }
              attrs.merge(actorable: actor) if track_actor && actor
              trackings.create!(attrs)
            end
          else
            define_method("#{field}!") do |happened_at=Time.now, actor: nil|
              tracking = send("#{field}_sidetrack")
              tracking.happened_at = happened_at
              tracking.actorable = actor if track_actor && actor
              tracking.save!
            end
          end

          define_method("#{field}_sidetrack") do
            trackings.find_or_initialize_by(event: field)
          end

          define_method("#{field}_at") do
            send("#{field}_sidetrack").happened_at
          end

          define_method("#{field}?") do
            send("#{field}_at").present?
          end

          if track_history
            define_method("#{field}_history") do
              trackings.send(field).order('happened_at desc').pluck(:happened_at)
            end
          end

          if track_actor
            define_method("#{field}_by") do
              send("#{field}_sidetrack").actorable
            end
          end
        end
      end
    end
  end
end
