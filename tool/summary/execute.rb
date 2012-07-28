# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('summary', 'Application summary')

require 'active_record'
require 'yaml'

require '../app/models/application_model'
require '../app/models/author'
require '../app/models/affiliate'
require '../app/models/movie'
require '../app/models/seen'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds["development"])


# authors
authors = Author.where :negative => 0
monitor.append 'users.all', authors.count
monitor.append 'users.facebook', authors.where(:provider => 'facebook').count
monitor.append 'users.twitter', authors.where(:provider => 'twitter').count
monitor.append 'users.google_oauth2', authors.where(:provider => 'google_oauth2').count

# seens
seens = Seen.where :negative => 0
monitor.append 'seens.all', seens.count


monitor.aging

