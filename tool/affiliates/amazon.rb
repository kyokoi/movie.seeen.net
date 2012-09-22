# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('update_affiliates', 'Affiliate URL更新バッチ')

require 'amazon/ecs'
require 'active_record'
require 'yaml'

require '../app/models/application_model'
require '../app/models/affiliate'
require '../app/models/movie'



# Defining.
NUMBER_OF_AFFILIATE_BY_MOVIE  = 3
#NUMBER_OF_FANDATION           = 20
NUMBER_OF_FANDATION           = 3000


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])


def offset_count
  now = Time.now
  now = Time.mktime(now.year, now.month, now.day, 0, 0, 0)
  (now.to_i / 60 / 60 / 24) % NUMBER_OF_FANDATION
end


# setup Amazon::Ecs
Amazon::Ecs.configure do |options|
  options[:associate_tag]     = 'movieseeennet-22'
  options[:AWS_access_key_id] = 'AKIAI24L65PGOCKX6WPA'
  options[:AWS_secret_key]    = '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'
end
#Amazon::Ecs.debug = true


# taget movies at this time.
movies = Movie.where :negative => 0
all    = movies.count
limit  = (all / NUMBER_OF_FANDATION).to_i
offset = offset_count

movies = movies.limit(limit).offset(offset)
movies = movies.order 'open_date desc'

monitor.append '更新対象', "Offset:#{offset}", "Limit:#{limit}", "All:#{all}"

movies.each do |movie|
  title = movie.name_of_japan
  title = movie.name_of_original if title.blank?
  if title.blank?
    monitor.append 'Title text is blank', "movieid:#{movie.id}"
    next
  end

  affiliates = Affiliate.where :negative => 0, :movie_id => movie.id

  begin
    res = Amazon::Ecs.item_search(
      title,
      {:country => 'jp', :search_index => 'All', :response_group => 'Medium'}
    )
    if res.has_error?
      keyword = CGI.unescapeHTML(res.error)
      monitor.append(keyword, 'movieid', movie.id, keyword)
      next
    end
  rescue => exception
    monitor.append exception
    monitor.aging
    exit 1
  end

  ecs_items = []
  res.items.each_with_index do |item, index|
    ecs_items << {
      :movie_id => movie.id,
      :name     => CGI.unescapeHTML(item.get('ItemAttributes/Title')),
      :url      => item.get('DetailPageURL'),
      :order_by => index,
      :negative => 0
    }
  end
  ecs_items = ecs_items.slice(0, NUMBER_OF_AFFILIATE_BY_MOVIE)
  puts "update #{ecs_items.count} affiliates on movie id [#{movie.id}] effected."

  affiliates_updated = affiliates.slice(0, ecs_items.count)
  affiliates_deleted = affiliates.slice(ecs_items.count, affiliates.count)
  affiliates_deleted = [] if affiliates_deleted.nil?

  affiliates_updated.each do |affiliate|
    item = ecs_items.shift

    affiliate.name     = item[:name]
    affiliate.url      = item[:url]
    affiliate.order_by = item[:order_by]
    affiliate.negative = 0
    affiliate.save
  end

  affiliates_deleted.each do |affiliate|
    puts "delete item"#{affiliates.id}"
    affiliate.destroy
  end

  ecs_items.each do |item|
    affiliate = Affiliate.new item
    affiliate.save
  end
end

monitor.aging

