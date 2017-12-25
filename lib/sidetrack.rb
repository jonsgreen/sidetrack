module Sidetrack
  require 'sidetrack/config'
  class Railtie < Rails::Railtie
    initializer 'sidetrack.active_record' do |app|
      ActiveSupport.on_load(:active_record) do
        require 'sidetrack/tracking'
        require 'sidetrack/model'
        include ::Sidetrack::Model
      end
    end
  end

  def self.config
    @config ||= Sidetrack::Config.instance
  end
end
