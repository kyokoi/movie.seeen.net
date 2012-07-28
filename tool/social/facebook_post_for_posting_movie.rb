# -*- coding: utf-8 -*-

require './lib/monitor'
require 'open-uri'
monitor = MovieSeen::Monitor.wakeup('social-facebook-post_each_update_movie', 'Facebook - Post each update movie')

require 'active_record'
require 'yaml'
require 'koala'

require '../app/models/application_model'
require '../app/models/author'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds["development"])

APP_APP_KEY = '203276849782760'
APP_SECRET  = '96fe96e404af7405790b60c12db77d37'

access_url = "https://graph.facebook.com/oauth/access_token?client_id=#{APP_APP_KEY}&client_secret=#{APP_SECRET}&grant_type=client_credentials"
monitor.append 'log', access_url
puts access_url
access_token = open access_url do |sock|
   sock.read
end
puts access_token
monitor.append 'log', access_token


#
author_id = 1
author = Author.active.where(:id => author_id).first
if author.blank?
  monitor.append 'user not exist', author_id
  exit
end


api = Koala::Facebook::API.new access_token
author_object = api.get_object author.uid
api.put_wall_post('hello, world', {:name => '映画箱', :link => 'http://movie.seeen.net/'})

puts api.inspect
puts sum.inspect

#me, friends = api.batch do |batch_api|
#  batch_api.get_object('me')
#  batch_api.get_connections('me', 'insights', {}, {"access_token" => ACCESS_TOKEN})
#end
#puts me.inspect
#puts friends.inspect



#monitor.aging

