if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.load do
    set :repository, "."
    set :scm,        :passthrough

    namespace :deploy do
      task :restart do
        run "touch #{torquebox_home}/jboss/standalone/deployments/#{application}-knob.yml.dodeploy"
      end

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
          task :deploy do
            execute = ["cd #{current_path}"]
            execute << "torquebox deploy . --env=#{rails_env} --context-path=#{app_context} --name=#{application}"
            run execute.join("&&")
          end
        end
      end

      before "deploy:update_code",      "deploy:torquebox:knob:prepare"
      before "deploy:finalize_update",  "deploy:torquebox:knob:distribute"
      after  "deploy:update",           "deploy:migrate"
      after  'deploy:create_symlink',   'deploy:torquebox:knob:deploy'
      after  'deploy:rollback:revision','deploy:torquebox:knob:deploy'
    end
  end
end
