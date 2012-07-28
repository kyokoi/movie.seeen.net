# encoding: utf-8

class MyController < ApplicationController
  def activity
    @my = Author.active.where(:id => params[:author_id]).first
    if @my.blank?
      return redirect_to search_path
    end

    @month = MonthlySeen.active.where :author_id => @my.id
    @month = @month.active.order "date DESC"

  end
end
