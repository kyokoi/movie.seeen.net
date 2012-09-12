# encoding: utf-8

class PostController < ApplicationController
  def index
    page_title "特集記事一覧"
    keywords "特集記事一覧"
    description "気になる映画は公開直前の映画、今見ておきたい映画をその時その時に合わせた内容で記事にしました。"

    @posts = Story.active.order "release_at DESC"
  end

  def story
    @story = Story.active.find params[:story_id]

    page_title "#{@story.title} - 特集記事"
    keywords "特集記事一覧"
    description "#{@story.contents.gsub("\r\n", "")[0, 80]}…"
  end
end
