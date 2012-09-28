# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('movies_results', '`movies`に関する集計')

require 'active_record'
require 'yaml'

require '../app/models/movie'
require '../app/models/seen'
require '../app/models/movies_reslut'


# Definings.
RANKING_LIMIT = 10


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])


movie_id = ARGV.first
if movie_id.blank?
  monitor.append("uncorrect argument").aging
  exit
end

movie = Movie.find_by_id_and_negative movie_id, 0
if movie.blank?
  monitor.append("uncorrect argument", "target id:#{movie.id}").aging
  exit
end

seens = Seen.where :negative => 0, :movie_id => movie.id
result = movie.result_of_seen
result.number = seens.count
result.save

stars     = Seen.stars.where :movie_id => movie_id
result = movie.result_of_star
result.number = stars.count
result.save

wishes    = Seen.wishes.where :movie_id => movie_id
result = movie.result_of_wish
result.number = wishes.count
result.save


monitor.aging

