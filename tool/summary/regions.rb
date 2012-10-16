# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('summary_regions', 'Movie belongs Region')

require 'active_record'
require 'yaml'

require '../app/models/movie'
require '../app/models/tag'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])



monitor.append 'fetch all movie data.'
tables = Hash.new
Movie.active.each do |movie|
  begin
    movie.category.split(/,/).each do |id|
      tag = Tag.active.find id
      tables[tag.id] ||= 0
      tables[tag.id]  += 1
    end
  rescue Exception => e
    monitor.append 'not found tag id', id
  end
end

monitor.append 'output data of yaml.'
File.write "#{ENV['MS_ROOT']}/../data/summaries/region_of_movie.yml", tables.to_yaml

monitor.aging
