# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('summary', 'Application summary')

require 'active_record'
require 'yaml'

require '../app/models/author'
require '../app/models/affiliate'
require '../app/models/movie'
require '../app/models/seen'
require '../app/models/seen_comment'


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

# added authors
added_authors = Author.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.yesterday} 23:59:59")
monitor.append 'users.added.yesterday', added_authors.count

# seens
seens = Seen.active.where(Seen.no_wish)
monitor.append 'seens.all', seens.active.count

# added seens
added_seens = Seen.all_seens.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.yesterday} 23:59:59")
monitor.append 'seens.added.yesterday', added_seens.count

# seen comments
seen_comments = SeenComment.active
monitor.append 'seen_comments.all', seen_comments.count

# added seen comments
added_seen_comments = SeenComment.active.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.yesterday} 23:59:59")
monitor.append 'seen_comments.added.yesterday', added_seen_comments.count

# added wishlist
added_wishlist = Seen.wishlist.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.yesterday} 23:59:59")
monitor.append 'wishes.added.yesterday', added_wishlist.count

# movies
movies = Movie.active
monitor.append 'movies.all', movies.active.count

# added movies
added_movies = Movie.where("created_at BETWEEN ? AND ?","#{Date.yesterday} 00:00:00", "#{Date.yesterday} 23:59:59")
monitor.append 'movies.added.yesterday', added_movies.count

monitor.aging
