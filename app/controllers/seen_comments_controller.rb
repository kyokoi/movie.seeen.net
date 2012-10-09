# encoding: utf-8

class SeenCommentsController < ApplicationController
  before_filter :fixed_seen

  # GET /seen_comments
  # GET /seen_comments.json
  def index
    @seen_comments = SeenComment.active.where(:seen_id => @seen.id).order('posted_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seen_comments }
    end
  end

  # GET /seen_comments/new
  # GET /seen_comments/new.json
  def new
    @seen_comment = SeenComment.new
    unless @seen_comment.author.id == @author.id
      raise Exception.new '権限がありません'
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seen_comment }
    end
  end

  # GET /seen_comments/1/edit
  def edit
    @seen_comment = SeenComment.find(params[:id])
    unless @seen_comment.author.id == @author.id
      raise Exception.new '権限がありません'
    end
  end

  # POST /seen_comments
  # POST /seen_comments.json
  def create
    @seen_comment = SeenComment.new(params[:seen_comment])
    @seen_comment.seen_id   = @seen.id
    @seen_comment.author_id = @author.id
    @seen_comment.posted_at = Time.now

    unless @seen_comment.author.id == @author.id
      raise Exception.new '権限がありません'
    end

    respond_to do |format|
      if @seen_comment.save
        format.html do
          redirect_to movie_seen_seen_comments_path(@seen.movie, @seen), notice: 'SeenComment was successfully created.'
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  # PUT /seen_comments/1
  # PUT /seen_comments/1.json
  def update
    @seen_comment = SeenComment.find(params[:id])

    unless @seen_comment.author.id == @author.id
      raise Exception.new '権限がありません'
    end

    respond_to do |format|
      if @seen_comment.update_attributes(params[:seen_comment])
        format.html do
          redirect_to movie_seen_seen_comments_path(@seen.movie, @seen), notice: 'SeenComment was successfully updated.'
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /seen_comments/1
  # DELETE /seen_comments/1.json
  def destroy
    @seen_comment = SeenComment.find(params[:id])
    @seen_comment.destroy

    unless @seen_comment.author.id == @author.id
      raise Exception.new '権限がありません'
    end

    respond_to do |format|
      format.html do
        redirect_to movie_seen_seen_comments_path(@seen.movie, @seen), notice: 'コメントを削除しました'
      end
    end
  end


  private

  def fixed_seen
    @seen = Seen.active.find params[:seen_id]
    unless @seen.movie.id == params[:movie_id].to_i
      raise Exception.new "incorrect parameter[movie:%s][seen:%s]" % [
        params[:movie_id], params[:seen_id]
      ]
    end

    page_title "#{@seen.movie.name_of_japan}に対する#{@seen.author.name}さんのコメントの返信"
    description @seen.comment
    keywords    @seen.movie.name_of_japan
  end
end
