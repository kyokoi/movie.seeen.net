# encoding: utf-8

class MyController < ApplicationController
  before_filter :fixed_author
  before_filter :check_narrow_parameter_for_watches

  SUMMARY_LIMIT = 5
  RECOMMEND_DIR = "#{Rails.root.to_s}/data/recommend"

  def summary
    page_title "#{@my.name}さんの映画管理 サマリページ"
    description "#{@my.name}さんのお気に入りの映画、見たい映画、見たことある映画、#{@my.name}さんの映画嗜好に近い人たちが分かります。"

    @recently_seen = Seen.all_seens @my.id
    @recently_seen = @recently_seen.order('date desc').order('id desc')
    @recently_seen = @recently_seen.limit SUMMARY_LIMIT

    @movies, @watches, @wishes = analyze_outline @my.id

    some_seen = Seen.active.where(:author_id => @my.id)
    some_seen = some_seen.order('date desc').order('id desc')

    @wish_seen = some_seen.where Seen.wish
    @wish_seen = @wish_seen.limit(SUMMARY_LIMIT)

    if @my.id != @author.id
      @star_seen = some_seen.stars
      @star_seen = @star_seen.limit SUMMARY_LIMIT
    end

    @recommend_users = fetch_recommend @my.id

    @display        = SUMMARY_LIMIT
    @weekly_ranking = fetch_ranking [:weekly_movie]
    @wishs_ranking  = fetch_ranking [:wishs]

    @monthly = MonthlySeen.active.where :author_id => @my.id
    @monthly = @monthly.monthly(DateTime.now).first
    if @monthly.blank?
      @monthly = MonthlySeen.new do |mons|
        mons.author_id = @my.id
        mons.date      = DateTime.now
        mons.all       = 0
        mons.stars     = 0
        mons.wishes    = 0
      end
    end
  end

  def watches
    page_title "#{@my.name}さんの映画管理 映画ページ"
    description "#{@my.name}さんのお気に入りの映画、見たい映画、見たことある映画"

    @matches_all =  Seen.all_seens(@my.id).order('date desc').order('id desc')
    @matches_star = @matches_all.where Seen.star
    @matches_wish = Seen.wishlist.where :author_id => @my.id

    case params[:narrow]
    when 'star'
      @matches = @matches_star
    when 'wish'
      @matches = @matches_wish
    else
      @matches = @matches_all
    end
  end

  def analyze
    page_title "#{@my.name}さんの映画管理 分析ページ"
    description "#{@my.name}さんの映画傾向・嗜好が分かります。"

    kinds = [:weekly_seen, :monthly_seen, :yearly_seen, :all_seen]
    @seens_ranks = {}
    kinds.each do |kind|
      rank = RankingIterator.new(kind,Author).rank(@my) || 0
      begin
        unless rank == 0
          @seens_ranks[kind] = rank
        end
        @seens_ranks[kind] = "-" if rank == 0
      rescue Exception => e
        logger.warn "Failure marshal processing.[#{kind}][#{e}]"
        nil
      end
    end

    @movies, @watches, @wishes = analyze_outline @my.id

    @region_tables = summarize_regions @watches

    @watch_yearly  = {}
    @movie_yearly  = {}
    @watches.order("date DESC").each do |watch|
      @watch_yearly[watch.date.strftime('%Y')] ||= 0
      @watch_yearly[watch.date.strftime('%Y')]  += 1

      @movie_yearly[watch.movie.open_date.strftime('%Y')] ||= 0
      @movie_yearly[watch.movie.open_date.strftime('%Y')]  += 1
    end
  end

  def recommend
    page_title "#{@my.name}さんの映画管理 レコメンドページ"
    description "#{@my.name}さんと似た嗜好の人が探せます。"

    @recommend_users = fetch_recommend @my.id
  end

  def activity
    page_title "あなたの映画活動"
    description "年間、月間に映画をどれくらい見たかが分かります。意外に忘れてますよ。"

    @my = Author.active.where(:id => params[:author_id]).first
    if @my.blank?
      return redirect_to search_path
    end

    @month = MonthlySeen.active.where :author_id => @my.id
    @month = @month.active.order "date DESC"
  end


  private

  def summarize_regions(watches)
    tables = []
    watches.order("date DESC").each do |watch|
      next if watch.movie.category.blank?
      watch.movie.category.split(/,/).each do |id|
        begin
          tag = tables.detect{|tag| tag.id == id.to_i}
          unless tag
            tag = Tag.active.find id
            class << tag
              attr_accessor :watch_number

              def add_number
                if self.watch_number.nil?
                  self.watch_number = 0
                end
                self.watch_number += 1
              end

              def watch_ratio
                if @region_tables.nil?
                  @region_of_movie = Hash.new
                  begin
                    movies_sumarrized = YAML.load_file(
                      "#{Rails.root.to_s}/data/summaries/movies.yml"
                    )
                    @region_of_movie = movies_sumarrized[:regions]
                  rescue Exception => e
                    logger.error e
                  end
                end

                return '-' if @region_of_movie[self.id].nil?
                self.watch_number / @region_of_movie[self.id].to_f
              end
            end
            tables << tag
          end
          tables.each do |tag|
            next unless tag.id == id.to_i
            tag.add_number
          end
        rescue Exception => e
          logger.error "Not found tag id [#{id}]"
        end
      end
    end
    tables.sort do |a, b|
      a.watch_number < b.watch_number ? 1 : -1
    end
  end

  def fetch_recommend(author_id)
    directory_name = "#{RECOMMEND_DIR}/#{Digest::MD5.hexdigest(author_id.to_s)[0, 2]}"
    users = YAML.load_file "#{directory_name}/#{author_id}.yml"
    recommends = users.map do |user_id, approximation|
      recommend_user = Author.active.where(:id => user_id)
      if recommend_user.first.blank?
        next
      end
      {:id => user_id, :name => recommend_user.first.name, :approximation => approximation}
    end
    recommends
  rescue Exception => e
    []
  end

  def fixed_author
    @my = Author.active.where(:id => params[:author_id]).first
    if @my.blank?
      return redirect_to search_path
    end
  end

  def check_narrow_parameter_for_watches
    unless action_name == 'watches'
      return
    end
    if params[:narrow].blank?
      return redirect_to my_watches_path @my
    end
    unless ['all', 'star', 'wish'].include? params[:narrow]
      return redirect_to my_watches_path @my
    end
  end

  def analyze_outline(id)
    movies  = Movie.active
    watches = Seen.all_seens id
    wishes  = Seen.active.wishes id
    class << watches
      def your_times
        your_minuts = self.inject(0) do |sum, watch|
          sum + watch.movie.show_time
        end
        your_minuts / (60.0 * 24)
      end
    end
    return movies, watches, wishes
  end
end
