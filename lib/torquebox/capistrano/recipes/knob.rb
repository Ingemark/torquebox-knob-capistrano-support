require 'torquebox-capistrano-support'

module Capistrano
  module TorqueBox
    def self.load_into(configuration)
      configuration.load do
        set :repository,  "."
        set :scm,         :passthrough
        set :revision,    lambda {fetch(:v, nil) || Capistrano::CLI.ui.ask("Version: ") }

        namespace :deploy do
          namespace :torquebox do
            namespace :knob do
              task :prepare do
                run "mkdir -p #{release_path}"
              end
              task :copy do
                run "wget -q -O #{release_path}/#{archive_name} #{archive_url}"
              end
              task :unjar do
                run "cd #{release_path} && jar -xf ./#{archive_name} && rm #{archive_name} && chmod -R +x vendor/bundle"
              end
              task :distribute do
                copy
                unjar
              end
            end
          end
        end

        before "deploy:update_code",      "deploy:torquebox:knob:prepare"
        before "deploy:finalize_update",  "deploy:torquebox:knob:distribute"
        after  "deploy:update",           "deploy:migrate"
      end
    end
  end
end

Capistrano::TorqueBox.load_into(Capistrano::Configuration.instance) if Capistrano::Configuration.instance
