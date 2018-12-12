# coding: utf-8
Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = "torquebox-knob-capistrano-support"
  s.version           = File.read(File.expand_path('../VERSION',__FILE__)).strip
  s.summary           = "Capistrano knob archive deployment support."
  s.description       = "Capistrano deploy strategy that transferes knob file from distribution
                         server to remote machines."

  s.homepage          = "https://github.com/Ingemark/torquebox-knob-capistrano-support"
  s.email             = "zeljko.juric@inge-mark.hr"
  s.authors           = [ "Željko Jurić" ]
  s.has_rdoc          = false

  s.files             = Dir['lib/**/*', 'README.md']

  s.add_dependency 'capistrano-deploy-scm-passthrough', '~> 0.1.1'
  s.add_dependency 'torquebox-capistrano-support',      '~> 2.3.2'
end
