# -*- coding: utf-8 -*-

require './lib/monitor'
monitor = MovieSeen::Monitor.wakeup('ranking', 'Rankings')

require 'active_record'
require 'yaml'


OUTPUT_DIR = '/usr/local/apps/movie_seen/data/ranking/'


# setup Active record
ConfigFile = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
ds = YAML.load(File.read(ConfigFile))
ActiveRecord::Base.establish_connection(ds["development"])


def movie_count(title, display, target_date, monitor)
  # arguments
  result_set = {
    :title      => title,
    :display    => display,
    :date_start => DateTime.now,
    :date_end   => target_date,
    :set => []
  }

  sql = "select m.id, m.name_of_japan as name, count(*) as number from movies m, seens s where m.id = s.movie_id and m.negative = 0 and s.negative = 0 and s.evaluation != 84 and s.date between '#{result_set[:date_end].strftime("%Y-%m-%d")} ' and '#{result_set[:date_start].strftime("%Y-%m-%d")}' group by m.id order by number DESC limit 100;"
  rs = ActiveRecord::Base.connection.execute(sql);
  rs.each do |row|
    result_set[:set] << {
      :name   => row[1],
      :number => row[2],
      :link   => "/movie/#{row[0]}/seens"
    }
  end

  File.write("#{OUTPUT_DIR}#{title}.yml", result_set.to_yaml)

  monitor.append('movie count', "type of #{title}");
end

def seen_count(title, display, target_date, monitor)
  # arguments
  result_set = {
    :title      => title,
    :display    => display,
    :date_start => DateTime.now,
    :date_end   => target_date,
    :set => []
  }

  # weekly ranking of seen.
  sql = "select a.id, a.name, count(*) as number from authors a, seens s where a.id = s.author_id and s.evaluation != 84 and s.date between '#{result_set[:date_end].strftime("%Y-%m-%d")}' and '#{result_set[:date_start].strftime("%Y-%m-%d")}' group by a.id order by number desc limit 100;"
  rs = ActiveRecord::Base.connection.execute(sql);
  rs.each do |row|
    result_set[:set] << {
      :name   => row[1],
      :number => row[2],
      :link   => "/search/?search[author]=#{row[0]}"
    }
  end

  File.write("#{OUTPUT_DIR}#{title}.yml", result_set.to_yaml)

  monitor.append('seen count', "type of #{title}");
end

def stars_count(title, display, target_date, monitor)
  # arguments
  result_set = {
    :title      => title,
    :display    => display,
    :date_start => DateTime.now,
    :date_end   => target_date,
    :set => []
  }

  sql = "select m.id, m.name_of_japan, count(*) as number from seens s, movies m where s.movie_id = m.id and s.negative = 0 and s.evaluation = 83 group by s.movie_id order by number desc;"
  rs = ActiveRecord::Base.connection.execute(sql);
  rs.each do |row|
    result_set[:set] << {
      :name   => row[1],
      :number => row[2],
      :link   => "/movie/#{row[0]}/seens"
    }
  end

  File.write("#{OUTPUT_DIR}#{title}.yml", result_set.to_yaml)

  monitor.append('star count', "type of #{title}");

end

current_date = DateTime.now
date_before_a_week  = current_date - 1.week
date_before_a_month = current_date - 1.month
date_before_a_year  = current_date - 1.year
date_before_older   = current_date - 100.year

seen_count('weekly_seen',  '映画を見た人ランキング（過去１週間）', date_before_a_week, monitor)
seen_count('monthly_seen', '映画を見た人ランキング（過去１ヶ月）', date_before_a_month, monitor)
seen_count('yearly_seen',  '映画を見た人ランキング（過去１年間）', date_before_a_year, monitor)
seen_count('all_seen',     '映画を見た人ランキング（過去全て）',   date_before_older , monitor)
movie_count('weekly_movie',  '見られた映画ランキング（過去１週間）', date_before_a_week, monitor)
movie_count('monthly_movie', '見られた映画ランキング（過去１ヶ月）', date_before_a_month, monitor)
movie_count('yearly_movie',  '見られた映画ランキング（過去１年間）', date_before_a_year, monitor)
movie_count('all_movie',     '見られた映画ランキング（過去全て）',   date_before_older,  monitor)

stars_count('stars', 'スター', nil, monitor)

monitor.aging

