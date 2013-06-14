require 'torquebox-capistrano-support'

module Capistrano
  module Torquebox
    module Knob
      def self.load_into( configuration )
        configuration.load do
          set :repository, "."
          set :scm,        :passthrough

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
                  run "cd #{release_path} && jar -xf ./#{archive_name} && rm #{archive_name}"
                end
                task :distribute do
                  copy
                  unjar
                end
              end
            end
          end

          before "deploy:update_code", "deploy:torquebox:knob:prepare"
          before "deploy:finalize_update", "deploy:torquebox:knob:distribute"
          after  "deploy:torquebox:knob:distribute", 'deploy:migrate'
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Torquebox::Knob.load_into(Capistrano::Configuration.instance)
end