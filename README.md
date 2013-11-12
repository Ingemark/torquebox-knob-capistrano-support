# torquebox-knob-capistrano-support

## Overview
**torquebox-knob-capistrano-support** provides a simple way to deploy knob files with
[Capistrano](https://github.com/capistrano/capistrano). This method uses
[:passthrough](https://github.com/sorccu/capistrano-deploy-scm-passthrough) deploy strategy and copy
knob file using [wget](http://www.gnu.org/software/wget/) from distribution server to remote machines.

## Instalations
Add gem to project Gemfile

```ruby
gem 'torquebox-knob-capistrano-support',
  :git => 'git://github.com/Inge-mark/torquebox-knob-capistrano-support.git',
  :tag => "0.2.3"
```

#Usage
Set your variables as follows:
```ruby
set :archive_name,    "<knob-name>.knob"
set :archive_url,     "http://<distribution-host>/<path-to-knob-file>"
set :torquebox_home,  "<remote-host-torquebox-dir>"
set :app_host,        "<jboss-virtual-host>"
set :app_context,     "<context>"
set :pooling,         { 'jobs' => { 'min' => 3, 'max' => 10 } } # Optional
```
and

```shell
cap deploy
```
Enjoy!
