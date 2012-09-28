# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('summary', 'Application summary')

require 'active_record'
require 'yaml'

require '../app/models/author'
require '../app/models/affiliate'
require '../app/models/movie'
require '../app/models/seen'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])


# authors
authors = Author.where :negative => 0
monitor.append 'users.all', authors.count
monitor.append 'users.facebook', authors.where(:provider => 'facebook').count
monitor.append 'users.twitter', authors.where(:provider => 'twitter').count
monitor.append 'users.google_oauth2', authors.where(:provider => 'google_oauth2').count

# seens
seens = Seen.active.where(Seen.no_wish)
monitor.append 'seens.all', seens.count

# added authors
added_authors = Author.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.today} 23:59:59'")
monitor.append 'yesterday.added.users', added_authors.count

# added movies
added_movies = Movie.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.today} 23:59:59'")
monitor.append 'yesterday.added.movies', added_movies.count

# added seens
added_seens = Seen.all_seens.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.today} 23:59:59'")
monitor.append 'yesterday.added.seens', added_seens.count

# added wishlist
added_wishlist = Seen.wishlist.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.today} 23:59:59'")
monitor.append 'yesterday.added.wishlist', added_wishlist.count
monitor.aging

