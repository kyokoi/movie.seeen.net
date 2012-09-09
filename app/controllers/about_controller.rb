class AboutController < ApplicationController
  def index
    page_title "映画箱：観た映画管理サイト　観たい映画管理サイト"
    description "観た映画は記録しよう。観たい映画もメモしよう。思い出の映画は、管理、記録、メモ。自分だけの映画履歴を作っちゃおう。日本最大級の映画管理サイトを目指します。"
  end


  protected

  def redirect_to_login_if_one_do_not
    logged_in?
  end
end
