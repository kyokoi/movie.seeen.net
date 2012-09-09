# encoding: utf-8

require 'net/http'

class SearchMovie < ActiveResource::Base

  BASE_HOST    = 'shma.jp'
  BASE_PORT    = 8983
  BASE_PATH    = '/solr/collection1/select'
  DEFAULT_ROWS = 2

  self.logger       = Logger.new('/usr/local/apps/movie_seen/log/development.log')
  self.timeout      = 3

  attr_accessor :keywords, :offset, :limit

  def pull
    @keywords = @keywords || ''
    words = @keywords.gsub '　', ' '

    queries = words.split(/ /).map do |word|
      "(name:#{word} OR name_ja:#{word} OR outline:#{word})"
    end

    offset = @offset || 0
    query  = queries.join(' AND ') + '&sort=seen_count desc'

    json = nil
    http = Net::HTTP.new BASE_HOST, BASE_PORT
    http.start do |conn|
      params = {
        :q     => '*:*',
        :fq    => query,
        :start => offset * @limit,
        :rows  => @limit,
        :wt    => 'json'
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

    return header, response
  end
end
