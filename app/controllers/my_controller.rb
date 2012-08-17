# encoding: utf-8

class MyController < ApplicationController

  SUMMARY_LIMIT = 3
  RECOMMEND_DIR = '/usr/local/apps/movie_seen/data/recommend'

  def activity
    @my = Author.active.where(:id => params[:author_id]).first
    if @my.blank?
      return redirect_to search_path
    end

    @month = MonthlySeen.active.where :author_id => @my.id
    @month = @month.active.order "date DESC"
  end

  def summary
    @my = Author.active.where(:id => params[:author_id]).first
    if @my.blank?
      return redirect_to search_path
    end

    @recently_seen = Seen.all_seens @author.id
    @recently_seen = @recently_seen.order('date desc').order('id desc')
    @recently_seen = @recently_seen.limit(SUMMARY_LIMIT)

    @wish_seen = Seen.active.where(:author_id => @author.id)
    @wish_seen = @wish_seen.where Seen.wish
    @wish_seen = @wish_seen.order('date desc').order('id desc')
    @wish_seen = @wish_seen.limit(SUMMARY_LIMIT)

    @recommend_users = fetch_recommend @my.id

    @display        = 3
    @weekly_ranking = fetch_ranking [:weekly_movie]
    @wishs_ranking  = fetch_ranking [:wishs]
  end


  private

  def fetch_recommend(author_id)
    directory_name = "#{RECOMMEND_DIR}/#{Digest::MD5.hexdigest(author_id.to_s)[0, 2]}"
    users = YAML.load_file "#{directory_name}/#{author_id}.yml"
    recommends = users.map do |user_id, point|
      recommend_user = Author.active.where(:id => user_id)
      if recommend_user.first.blank?
        next
      end
      {:id => user_id, :name => recommend_user.first.name}
    end
    recommends
  rescue Exception => e
    []
  end
end
