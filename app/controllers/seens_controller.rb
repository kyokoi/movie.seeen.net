# encoding: utf-8

class SeensController < ApplicationController
  before_filter :fixed_movie

  def wish_new
    seen = Seen.new
    seen.movie_id  = params[:movie_id]
    seen.author_id = @author.id
    seen.date      = Date.today
    seen.acondition = ""
    seen.comment    = ""
    seen.evaluation = Seen::EVALUATION_WISH_ID
    seen.negative   = false

    respond_to do |format|
      if seen.save
        format.html { redirect_to movie_seens_path, notice: '見たい映画を追加しました' }
      else
        format.html { redirect_to movie_seens_path, notice: 'Addition miss' }
      end
    end
  end

  def wish_delete
    seens = Seen.wishlist.where :author_id => @author.id
    seens = seens.where :movie_id => params[:movie_id]
    seens.each do |seen|
      seen.destroy
    end
    redirect_to movie_seens_path, :notice => '見たい映画を削除しました'
  end

  # GET /seens
  # GET /seens.json
  def index
    @seens = Seen.where(:movie_id => @movie.id)
    @seens = @seens.active

    @activity = {}
    @activity[:all]    = @seens.where(Seen.no_wish).count
    @activity[:stars]  = @seens.where(Seen.star).count
    @activity[:wishes] = @seens.where(Seen.wish).count

    case params[:narrow]
    when 'star'
      @seens = @seens.where Seen.star
    when 'seen'
      @seens = @seens.where Seen.no_star
      @seens = @seens.where Seen.no_wish
    when 'wish'
      @seens = @seens.where Seen.wish
    else
      @seens = @seens.where Seen.no_wish
    end
    @seens = @seens.order("date desc");

    wishlist = Seen.where(Seen.wish).where(:author_id => @author.id)
    wishlist = wishlist.where(:movie_id => @movie.id, :negative => 0)
    @has_wishlist = false
    @has_wishlist = true if wishlist.count > 0

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seens }
    end
  end

  # GET /seens/1
  # GET /seens/1.json
  def show
    @seen = Seen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seen }
    end
  end

  # GET /seens/new
  # GET /seens/new.json
  def new
    @seen = Seen.new

    @watch_areas, @useful_areas = select_watch_areas

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seen }
    end
  end

  # GET /seens/1/edit
  def edit
    @seen = Seen.find(params[:id])
    @watch_areas, @useful_areas = select_watch_areas
  end

  # POST /seens
  # POST /seens.json
  def create
    unless @author.id.to_i == params[:seen][:author_id].to_i
      return render(:action => "new")
    end

    @seen = Seen.active.where(
      :movie_id   => params[:seen][:movie_id],
      :author_id  => @author.id,
      :evaluation => Seen::EVALUATION_WISH_ID
    )
    if @seen.count > 0
      @seen = @seen.first
      @seen.date       = '%s-%s-%s' % [params[:seen]['date(1i)'], params[:seen]['date(2i)'], params[:seen]['date(3i)']]
      @seen.acondition = params[:seen][:accondition]
      @seen.comment    = params[:seen][:comment]
      @seen.evaluation = Seen::EVALUATION_STAR_ID
    else
      @seen = Seen.new(params[:seen])
    end

    respond_to do |format|
      if @seen.save
        format.html { redirect_to movie_seens_path, notice: '記録しました！' }
        format.json { render json: @seen, status: :created, location: @seen }
      else
        format.html { render action: "new" }
        format.json { render json: @seen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seens/1
  # PUT /seens/1.json
  def update
    unless @author.id.to_i == params[:seen][:author_id].to_i
      @tags_for_acondition = list_for_tags
      return render(:action => "edit")
    end

    @seen = Seen.find_by_id_and_negative(params[:id], 0)

    respond_to do |format|
      if @seen.update_attributes(params[:seen])
        format.html { redirect_to movie_seens_path, notice: '変更しました！' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @seen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seens/1
  # DELETE /seens/1.json
  def destroy
    @seen = Seen.find_by_id_and_negative(params[:id], 0)
    @seen.destroy

    respond_to do |format|
      format.html { redirect_to movie_seens_path }
      format.json { head :no_content }
    end
  end


  private

  def fixed_movie
    @movie = Movie.find_by_id_and_negative(params[:movie_id], 0)
    page_title @movie.name_of_japan
  end

  def select_watch_areas
    watch_areas = []
    areas = Tag.active.where(Tag.area).order('order_by asc')
    areas.each do |area|
      watch_areas << {
        :area_id   => area.id,
        :area_name => area.name,
        :cinemas   => Tag.where(:negative => 0, :belong => area.id).order('order_by asc')
      }
    end

    useful_areas = []
    sql = "select acondition, count(*) as number from seens where author_id = #{@author.id} and acondition <> '' group by acondition order by number desc limit 10;"
    areas = ActiveRecord::Base.connection.execute(sql)
    areas.each do |area|
      tag = Tag.active.where(:id => area[0]).first
      next unless tag
      useful_areas << tag
    end

    [watch_areas, useful_areas]
  end
end
