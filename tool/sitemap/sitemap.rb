# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('sitemap', 'Sitemaps')

require 'active_record'
require 'yaml'

require '../app/models/author'
require '../app/models/movie'
require '../app/models/seen_comment'
require '../app/models/seen'
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
end

monitor.append('build xml', "all movies: priority 0.5");
publish_by_model(Movie.active, 'movies', 0.5) do |match|
  "/movie/#{match.id}/seens/"
end

monitor.append('build xml', "all stories: priority 0.8");
publish_by_model(Story.active, 'stories', 0.8) do |match|
  "/post/#{match.id}/"
end

monitor.append('build xml', "all seen comments: priority 0.6");
publish_by_model(SeenComment.active, 'seen_comments', 0.6) do |match|
  "/movie/%d/seens/%d/seen_comments" % [match.seen.movie.id, match.seen.id]
end


config = YAML.load_file File.join(BATCH_ROOT_DIR, "config.yml")
config['miscellaneous'].each do |misc|
  monitor.append('build xml', "#{misc}: priority 1.0");
end
pub.run config['miscellaneous'], 1.0, 'miscellaneous.xml'

monitor.append('pingning', "Google ping");
pub.indexing.ping

monitor.append 'batch summary', "url:#{pub.url_indexies}, xml:#{pub.xml_indexies}"
monitor.aging
