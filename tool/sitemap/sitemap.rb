# -*- coding: utf-8 -*-

require 'active_record'
require 'yaml'

require '../app/models/application_model'
require '../app/models/movie'
require '../app/models/story'

require './sitemap/publisher'


# setup Active record
ConfigFile = File.join(ENV['MS_ROOT'], "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection ds[ENV['MS_ENV']]



BATCH_ROOT_DIR = File.dirname __FILE__
ROTATE_COUNT   = 8000

pub = Publisher.instance
pub.host_name    = ENV['MS_HOST']
pub.template_dir = File.join BATCH_ROOT_DIR, "templates"
pub.save_dir     = File.join ENV['MS_ROOT'], "..", "public"



def publish_by_model(matches, map_name, priority)
  while rotate ||= 0
    matches = matches.limit(ROTATE_COUNT).offset(rotate * ROTATE_COUNT)
    break unless matches.count > 0

    pathes = matches.map do |match|
      yield match
    end

    save_file = "#{map_name}.#{rotate}.xml"

    pub = Publisher.instance
    pub.run pathes, priority, save_file

    rotate += 1
  end

  puts map_name
end

publish_by_model(Movie.active, 'movies', 0.5) do |match|
  "/movie/#{match.id}/seens/"
end
publish_by_model(Story.active, 'stories', 0.8) do |match|
  "/post/#{match.id}/"
end


config = YAML.load_file File.join(BATCH_ROOT_DIR, "config.yml")
pub.run config['miscellaneous'], 1.0, 'miscellaneous.xml'

pub.indexing.ping


puts "ping success"
