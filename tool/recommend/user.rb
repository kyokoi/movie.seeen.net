# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('recommend_by_user', 'User recommend.')

require 'active_record'
require 'yaml'

require '../app/models/application_model'
require '../app/models/author'
require '../app/models/seen'


OUTPUT_DIR = '/usr/local/apps/movie_seen/data/recommend/'
NUMBER_MAP = {
  :wish     => 1,
  :star     => 100,
  :comment  => 20,
  :date     => 50,
  :area     => 30,
  :movie    => 10
}
COUNT_LIMIT = 2
POINT_LIMIT = 30


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds["production"])


# select all user.
authors = Author.active

authors.each do |subject|
  recommend_authors = {}
  #seens_of_subject = Seen.active.stars.where(:author_id => subject.id).group(:movie_id)
  seens_of_subject = Seen.active.where(:author_id => subject.id).group(:movie_id)
  seens_of_subject.each do |seen_of_subject|
    candidates = Seen.active.where(:movie_id => seen_of_subject.movie_id).not(:author_id, subject.id)
    candidates.each do |candidate|
      recommend_authors[candidate.author_id] ||= {:count => 0, :number => 0}

      if candidate.wish?
        recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:wish]
        next
      end

      recommend_authors[candidate.author_id][:count] += 1
      recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:movie]
      if candidate.star?
        recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:star]
      end
      if seen_of_subject.date == candidate.date
        recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:date]
      end
      if candidate.acondition && seen_of_subject.acondition == candidate.acondition
        recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:area]
      end
      unless candidate.comment.blank?
        recommend_authors[candidate.author_id][:number] += NUMBER_MAP[:comment]
      end
    end
  end

  recommend_authors.delete_if do |author_id, aggregate|
    next true if aggregate[:count] < COUNT_LIMIT
    next true if (aggregate[:number] / aggregate[:count]) < POINT_LIMIT
    nil
  end
  tmp_points = {}
  recommend_authors.each do |author_id, aggregate|
    tmp_points[author_id] = aggregate[:number] / aggregate[:count]
  end
  points = {}
  tmp_points.sort do |a, b|
    b[1] <=> a[1]
  end.each do |author_id, point|
    points[author_id] = point
  end
  puts points.inspect

  # save
  directory_name = OUTPUT_DIR + Digest::MD5.hexdigest(subject.id.to_s)[0, 2]
  unless Dir.exists? directory_name
    Dir.mkdir directory_name
  end
  File.write("#{directory_name}/#{subject.id}.yml", points.to_yaml)
end

monitor.aging

