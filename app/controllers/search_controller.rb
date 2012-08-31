# encoding: utf-8

class SearchController < ApplicationController

  EACH_LIMIT_WHEN_SEARCH = 20

  before_filter do |controller|
    @each_limit_when_search = EACH_LIMIT_WHEN_SEARCH
    @offset = 0
  end

  def seens
    params[:search]          = params[:search] || {:narrow => ""}
    params[:search][:narrow] = params[:search][:narrow] || ""

    @matches, @search_count, @template = seen_search params[:search], 0

    oauthor = check_author params[:search][:author]
    target  = oauthor || @author

    @activity = {}
    @activity[:all]    = Seen.all_seens(target.id).count
    @activity[:stars]  = Seen.stars(target.id).count
    @activity[:wishes] = Seen.wishes(target.id).count

    @monthly = MonthlySeen.active.where :author_id => target.id
    @monthly = @monthly.monthly(DateTime.now).first
    if @monthly.blank?
      @monthly = MonthlySeen.new do |mons|
        mons.author_id = target.id
        mons.date      = DateTime.now
        mons.all       = 0
        mons.stars     = 0
        mons.wishes    = 0
      end
    end

    render 'seens'
  end

  def seens_list
    @offset = search_offset params[:offset]
    unless @offset > 0
      return render('list_error', :layout => false)
    end

    @matches, @search_count, @template = seen_search params[:search], @offset

    render 'list', :layout => false
  end

  def movies
    @matches, @search_count, @template = movies_search params[:search], 0
    render 'movies'
  end

  def movies_list
    @offset = search_offset params[:offset]
    unless @offset > 0
      return render('list_error', :layout => false)
    end

    @matches, @search_count, @template = movies_search params[:search], @offset

    render 'list', :layout => false
  end

  def how_to_use
  end

  def list
    @offset = search_offset params[:offset]
    unless @offset > 0
      return render('list_error', :layout => false)
    end
    @matches = search @offset do |matches, render_template|
      @search_count    = matches.count
      @render_template = render_template
    end

    render 'list', :layout => false
  end


  private

  def check_author(author_id)
    return false if author_id.blank?

    oauthor = Author.where :negative => 0, :id => author_id
    return false unless oauthor.count > 0
    oauthor.first
  end

  def seen_search(search, offset)
    matches = Seen.active

    oauthor = check_author search[:author]
    if oauthor
      matches = matches.where :author_id => oauthor.id
      search_condition search_condition (@author.guest? ? '名前無しさん' : oauthor.name)
    else
      matches = matches.where :author_id => @author.id
    end

    case params[:search][:narrow]
    when 'star'
      page_title 'あなたのお気に入り映画一覧'
      matches = matches.where Seen.star
    when 'seen'
      page_title 'あなたが見た映画一覧'
      matches = matches.where Seen.no_star
      matches = matches.where Seen.no_wish
    when 'wish'
      page_title 'あなたが見たい映画一覧'
      matches = matches.where Seen.wish
    else
      page_title 'あなたが見た全ての映画一覧'
      matches = matches.where Seen.no_wish
    end

    search_count = matches.count

    template = 'layouts/seen'
    unless matches.count > 0
      page_title '見た映画を探そう'
      template = 'at_beginner'
    end

    matches = matches.order('date desc').order('id desc')
    matches = matches.limit(EACH_LIMIT_WHEN_SEARCH)
    matches = matches.offset(offset * EACH_LIMIT_WHEN_SEARCH)

    return matches, search_count, template
  end

  def movies_search(search, offset)
    page_title '検索結果'
    matches = Movie.where :negative => 0
    if search
      if search[:word] && search[:word].size > 0
        search_condition "#{search[:word]}"
        matches = matches.text_search search[:word]
        page_title "#{params[:search][:word]}の検索結果"
      end
    end
    template = 'no_hit'
    template = 'search_to_movie' if matches.count > 0
    search_count = matches.count

    matches = matches.order('open_date desc').order('id desc')
    matches = matches.limit(EACH_LIMIT_WHEN_SEARCH)
    matches = matches.offset(offset * EACH_LIMIT_WHEN_SEARCH)

    return matches, search_count, template
  end

  def search(offset)
    if params[:search]
      matches = Movie.where :negative => 0
      if params[:search][:word] && params[:search][:word].size > 0
        search_condition "#{params[:search][:word]}"
        matches = matches.text_search params[:search][:word]

      end

      template = 'no_hit'
      template = 'search_to_movie' if matches.count > 0
      yield matches, template if block_given?
      matches = matches.order('open_date desc').order('id desc')
    else
      matches = Seen.where :negative => 0
      matches = matches.where(:author_id => @author.id)

      template = 'at_beginner'
      template = 'layouts/seen' if matches.count > 0
      yield matches, template if block_given?
      matches = matches.order('date desc').order('id desc')
    end
    matches = matches.limit(EACH_LIMIT_WHEN_SEARCH)
    matches = matches.offset(offset * EACH_LIMIT_WHEN_SEARCH)
  end

  def search_condition(word)
    @search_condition = word
  end

  def search_offset(offset)
    return 0 if offset.blank?
    return 0 if offset.to_i < 0
    offset.to_i
  end
end
