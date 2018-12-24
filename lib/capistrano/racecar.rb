# frozen_string_literal: true

require 'capistrano/bundler'
require 'capistrano/plugin'
module Capistrano
  class Racecar < Capistrano::Plugin
    CAP_FILES = %w[
      stop
      start
      restart
    ].freeze

    def define_tasks
      Capistrano::Racecar::CAP_FILES.each do |cap_file|
        eval File.open(File.expand_path("../tasks/#{cap_file}.cap", __FILE__), 'r').read
      end
    end

    def set_defaults
      set_if_empty :racecar_pid_prefix, 'racecar'
      set_if_empty :racecar_pid_path, 'pids'
      set_if_empty :racecar_consumers_path, 'app/consumers'
    end

    # Deploy hooks registration
    def register_hooks
      # deploy:published
      after 'deploy:published', 'racecar:restart'
    end
    SSHKit.config.command_map[:racecar] = 'bundle exec racecar'
  end
end
