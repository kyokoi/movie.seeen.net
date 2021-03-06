# encoding: utf-8

module ApplicationHelper

  def path_by_author(path, author)
    if author.guest?
      path = 'movies/_noimage.jpg'
    end
    path
  end

  def linksym
    simbol_string = '<span class="bow">›</span>'
  end

  def stars(evaluation)
    return_path = "layout/stars_off.png"
    if evaluation == "83"
      return_path = "layout/stars_on.png"
    end
    return_path
  end

  def activity_of_years(month)
    activities = {}
    month.each do |seen|
      if activities[seen.date.year].blank?
        activities[seen.date.year] = {
          :all    => 0,
          :stars  => 0,
          :wishes => 0
        }
      end

      activities[seen.date.year][:all]    += seen.all
      activities[seen.date.year][:stars]  += seen.stars
      activities[seen.date.year][:wishes] += seen.wishes
    end
    activities
  end

  def in_average_of_seens_monthly(month)
    total = in_total_of_seens month
    "%.2f" % (total.to_f / month.size.to_f)
  end

  def in_total_of_seens(month)
    month.map{|seen| seen.all}.inject(0){|sum, i| sum + i}
  end

  def display_story(story, &block)
    contents = story.search_movie do |line, mark, movie|
      banner = capture(movie, &block).gsub(/\n/, '')
      line.gsub! mark, banner
      line
    end
    concat raw(simple_format(contents))
  end

  def display_boradcast_time(onair_time)
    if ((Time.now - 2.hours)..(Time.now)).cover? onair_time
      return '<span class="emphasis">Now on air</span>'
    end
    if ((Time.now.beginning_of_day)..(Time.now.end_of_day)).cover? onair_time
      return "<span class='emphasis'>今日 #{onair_time.strftime('%H:%M')}</span>"
    end
    if ((DateTime.tomorrow.beginning_of_day)..(DateTime.tomorrow.end_of_day)).cover? onair_time
      return "<span class='emphasis'>明日 #{onair_time.strftime('%H:%M')}</span>"
    end
    onair_time.strftime('%m月%d日 %H:%M')
  end

  def display_user_name(seen, author)
    if author.guest?
      if seen.wish?
        "#{seen.date.strftime('%m月%d日')}に「#{een.movie.name_of_japan}」を見たい人さん"
      else
        "#{seen.date.strftime('%m月%d日')}に「#{seen.movie.name_of_japan}」を見た人さん"
      end
    else
      seen.author.name
    end
  end
end
