require "rails/generators"
require "rails/generators/active_record"

module Sidetrack
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    class_option(
      :track_actors,
      type: :boolean,
      default: false,
      desc: "Adds a polymorphic association for tracking event actors"
    )

    desc "Generates (but does not run) a migration to add a sidetracks table."

    def create_migration_file
      add_sidetrack_migration("create_trackings")
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_sidetrack_migration(template)
      migration_dir = File.expand_path("db/migrate")
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          migration_version: migration_version,
          track_actors: track_actors,
        )
      end
    end

    private

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      if major >= 5
        "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end

    def track_actors
      options[:track_actors]
    end

  end
end
