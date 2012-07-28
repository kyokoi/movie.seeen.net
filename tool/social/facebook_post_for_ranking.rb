# -*- coding: utf-8 -*-

require './lib/monitor'
#monitor = MovieSeen::Monitor.wakeup('social', 'Facebook - Post for ranking')

require 'active_record'
require 'yaml'
require 'koala'


INPUT_DIR             = '/usr/local/apps/movie_seen/data/ranking/'

RETURN_URI = 'http://192.168.56.101/'

FACEBOOK_MOVIE_SEEN_APPLICATION_ID = '203276849782760'
FACEBOOK_MOVIE_SEEN_SECRET_KEY    = '96fe96e404af7405790b60c12db77d37'

ACCESS_TOKEN = 'AAAC44RRsHZBgBAEHhzVZAUWWEqWQGpsvToIVkSMkVN844NvoFqdGuxCituo7T7F01lYIQ8ZBho9lRpiY4irKAvNQe90dgYAKtWlzxwtRQZDZD'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds["development"])


api = Koala::Facebook::API.new(ACCESS_TOKEN)
me, friends = api.batch do |batch_api|
  batch_api.get_object('me')
  batch_api.get_connections('me', 'insights', {}, {"access_token" => ACCESS_TOKEN})
end
puts me.inspect
puts friends.inspect



#monitor.aging

