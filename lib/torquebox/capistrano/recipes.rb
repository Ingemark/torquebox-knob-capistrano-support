module Capistrano
  module TorqueBox
    def self.load_into(configuration)
      configuration.load do
        set :repository,  "."
        set :scm,         :passthrough

        set :torquebox_home,  "/opt/torquebox"
        set :jboss_home,      lambda{ "#{torquebox_home}/jboss" }
        set :jruby_home,      lambda{ "#{torquebox_home}/jruby" }

        namespace :deploy do
          task :restart do
            run "touch #{jboss_home}/standalone/deployments/#{application}-knob.yml.dodeploy"
          end

          namespace :torquebox do
            namespace :knob do
              task :env do
                default_environment["TORQUEBOX_HOME"] = torquebox_home
                default_environment["JBOSS_HOME"] = jboss_home
                default_environment["JRUBY_HOME"] = jruby_home
                default_environment["PATH"] = "#{jruby_home}/bin:$PATH"
              end
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
              task :deploy do
                execute = [" cd #{current_path} "]
                #deploy  = " PATH=#{jruby_home}/bin:#{jboss_home}/bin:$PATH "
                #deploy += " JBOSS_HOME=#{jboss_home} JRUBY_HOME=#{jruby_home} "
                deploy = " torquebox deploy . --env=#{rails_env} --name=#{application} "
                execute << deploy
                run execute.join("&&")
              end
            end
          end

          before "deploy",                  "deploy:torquebox:knob:env"
          before "deploy:update_code",      "deploy:torquebox:knob:prepare"
          before "deploy:finalize_update",  "deploy:torquebox:knob:distribute"
          after  "deploy:update",           "deploy:migrate"
          after  'deploy:create_symlink',   'deploy:torquebox:knob:deploy'
          after  'deploy:rollback:revision','deploy:torquebox:knob:deploy'
        end
      end
    end
  end
end

Capistrano::TorqueBox.load_into(Capistrano::Configuration.instance) if Capistrano::Configuration.instance
