# encoding: utf-8

class MyController < ApplicationController

  SUMMARY_LIMIT = 3

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

    @display        = 3
    @weekly_ranking = fetch_ranking [:weekly_movie]
    @wishs_ranking  = fetch_ranking [:wishs]
  end
end
