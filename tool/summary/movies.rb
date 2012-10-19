# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('summarize_movies', 'Summarize Movies')

require 'active_record'
require 'yaml'

require '../app/models/movie'
require '../app/models/tag'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])



monitor.append 'fetch all movie data.'
table_of_movies = {
  :regions => Hash.new,
  :ages    => Hash.new,
  :years   => Hash.new
}
Movie.active.each do |movie|
  begin
    movie.category.split(/,/).each do |id|
      tag = Tag.active.find id
      table_of_movies[:regions][tag.id] ||= 0
      table_of_movies[:regions][tag.id]  += 1
    end
  rescue Exception => e
    monitor.append 'not found tag id', id
  end

  age = (movie.open_date.strftime('%Y').to_i * 0.1).floor * 10
  table_of_movies[:ages][age] ||= 0
  table_of_movies[:ages][age]  += 1

  year = movie.open_date.strftime('%Y').to_i
  table_of_movies[:years][year] ||= 0
  table_of_movies[:years][year]  += 1
end

monitor.append 'output data of yaml.'
File.write "#{ENV['MS_ROOT']}/../data/summaries/movies.yml",    table_of_movies.to_yaml

#monitor.aging
