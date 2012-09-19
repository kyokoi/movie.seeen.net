# encoding: utf-8
require "net/smtp"
require "time"

toMail = "id.shma@gmail.com"
fromMail = "movie_seen"
subject = "No Hit Words"
body =""

now = Time.now-3600
open("/usr/local/apps/movie_seen/log/search_failed.log",:encoding => "UTF-8") {|f|
  message = f.select do |line|
    line.chomp!
    field = line.split(/\t/)
    log_time = Time.parse(field[0])
    if (log_time<=>now) == 1
      next true
    end
    next nil
  end.map {|a| a.split(/\t/)[1]}.uniq.join("\r\n")

if message.size == 0
  exit
end

body += "このワードでユーザーがサーチできてません！もっとがんばりましょう\r\n"
body += "(過去一時間でユーザーが検索できていないワードを表示しています)"
body += "\r\n---------------------------------------------------\r\n"
body +=  message
body += "\r\n--------------------------------------------------\r\n"
}

data = "Subject: #{subject}\n" + body

Net::SMTP.start('localhost', 25){|smtp|
  smtp.sendmail data, fromMail, toMail
}

