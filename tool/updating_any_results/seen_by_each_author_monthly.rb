# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('seen_by_each_author_monthly', 'ユーザ毎の月間登録数')

require 'active_support'
require 'active_record'
require 'yaml'

require '../app/models/author'
require '../app/models/seen'
require '../app/models/monthly_seen'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds[ENV['MS_ENV']])


def targets author
  seens = Seen.active.where :author_id => author.id
  seens = seens.order(:date).group("DATE_FORMAT(date, '%Y-%m')")
  puts seens.to_sql
  seens.each do |seen|
    count_each author, seen.date
  end
end

def count_each author, target_date
  target_year, target_month = target_date.strftime('%Y-%m').split /-/
  current_date = DateTime.new target_year.to_i, target_month.to_i
  start_date   = current_date.beginning_of_month
  end_date     = current_date.end_of_month

  seens  = Seen.active.where :author_id => author.id
  seens  = seens.where(:date => (start_date.to_date)..(end_date.to_date))

  all    = seens.where Seen.no_wish
  stars  = seens.where Seen.star
  wishes = seens.where Seen.wish

  monthly = MonthlySeen.active.where(:author_id => author.id, :date => start_date.to_date).first
  if monthly.blank?
    monthly = MonthlySeen.new do |monseen|
      monseen.author_id = author.id
      monseen.date      = start_date
    end
  end
  monthly.all    = all.count
  monthly.stars  = stars.count
  monthly.wishes = wishes.count

  monthly.save
end

authors = Author.active
authors.each do |author|
  targets author
end


monitor.aging

