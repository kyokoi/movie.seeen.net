# encoding: utf-8

require 'net/http'

class SearchMovie < ActiveResource::Base

  BASE_HOST    = 'shma.jp'
  BASE_PORT    = 8983
  BASE_PATH    = '/solr/collection1/select'
  SPECIALS     = '+ * ~ ! ( ) : { } [ ]'

  self.logger  = Logger.new("#{Rails.root.to_s}/log/#{Rails.env}.log")
  self.timeout = 3

  attr_accessor :keywords, :offset, :limit

  def pull
    @keywords = @keywords || ''
    words = @keywords.gsub '　', ' '
    words = @keywords.gsub '・', ' '

    queries = words.split(/ /).map do |word|
      SPECIALS.split(' ').each do |char|
        word.gsub! char, ''
      end
      word.gsub! ' ', ''
      next if word.blank?

      "(name:#{word} OR name_ja:#{word} OR outline:#{word} OR comment:#{word})"
    end

    offset = @offset || 0
    query  = queries.join(' AND ')

    json = nil
    http = Net::HTTP.new BASE_HOST, BASE_PORT
    http.open_timeout = 1
    http.read_timeout = 1
    http.start do |conn|
      params = {
        :q      => query,
        :start  => offset * @limit,
        :rows   => @limit,
        :wt     => 'json',
        :dismax => 'true',
        :qf     => 'name^2.0 outline^0.1'
      }
      queries = params.map do |key, value|
        URI.encode "#{key}=#{value}"
      end
      path = "#{BASE_PATH}?#{queries.join('&')}"
      logger.warn "solr: #{path}"
      response = conn.get path

      response_body = response.body
      json = JSON.parse(response_body)
    end

    header   = json['responseHeader']
    response = json['response']
    nohit    = Logger.new("#{Rails.root.to_s}/log/search_failed.log")
    hit      = Logger.new("#{Rails.root.to_s}/log/search_success.log")
    if json['response']['numFound'] == 0
      nohit.warn "#{Time.now}\t#{words}"
    else
      hit.warn "#{words}"
    end
    return header, response
  end
end
