require 'singleton'
require 'erb'
require 'uri'
require 'net/http'
require 'date'

# Usage:
#   pub = Publisher.instance
#   pub.host_name = 'example.com'
#   pub.save_dir  = '/usr/local/apache/htdocs/'
#   pub.template_dir = '/usr/local/yourapps/data/'
#   pub.run pathes, priority, save_file
#
#  - explain.
#    #{@save_dir} / sitemap_index.xml
#                   sitemap /
#
class Publisher
  include Singleton

  PING_URL = 'http://www.google.com/webmasters/tool/ping'

  attr_accessor :save_dir, :host_name, :template_dir
  attr_reader   :url_indexies, :xml_indexies

  def initialize
    @url_indexies = 0
    @xml_indexies = []
  end

  def host_name=(name)
    uri = URI.parse name
    @host_name = uri.host
  end

  def xml_indexies
    @xml_indexies.count
  end

  def run(pathes, priority, save_file)
    template = "#{@template_dir}/sitemap.xml.erb"
    erb = ERB.new IO.read(template), nil, '-'
    sitemap = erb.result(binding)

    File.open("#{@save_dir}/sitemap/#{save_file}", 'w') do |file|
      file.write sitemap
    end

    @url_indexies += pathes.count
    @xml_indexies << "http://#{@host_name}/sitemap/#{save_file}"
  end

  def indexing
    Dir.glob "#{@save_dir}/sitemap/*.gz" do |file|
      File.unlink file
    end
    Dir.glob "#{@save_dir}/sitemap/*" do |file|
      system("gzip "+file)
    end

    template = "#{@template_dir}/sitemap_index.xml.erb"
    erb = ERB.new IO.read(template), nil, '-'
    sitemap_index = erb.result(binding)
    File.open("#{@save_dir}/sitemap_index.xml", 'w') do |file|
      file.write sitemap_index
    end

    self
  end

  def ping
    sitemap_index_url = "http://#{@host_name}/sitemap_index.xml"

    Net::HTTP.version_1_2
    url = URI.parse "#{PING_URL}?sitemap=#{URI.encode(sitemap_index_url)}"

    res = Net::HTTP.start(url.host, url.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 5

      #http.get("#{path}?#{query}")
    end
  end
end
