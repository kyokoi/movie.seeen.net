require 'active_support'
require 'yaml'
require 'digest/md5'


module MovieSeen; end
class MovieSeen::Monitor
  CONFIGURE = '/usr/local/apps/movie_seen/data/monitor_of_batches/'

  attr_accessor = [:name, :start, :end]

  def self.wakeup(target, name = nil)
    name = target if name.nil?

    target_path = self.target_file target

    begin
      configure = YAML.load_file target_path
      unless configure
        return self.new target, name, DateTime.now, DateTime.now
      end
    rescue
      return self.new target, name, DateTime.now, DateTime.now
    end

    self.new(
      target, name,
      configure[:recent][:start], configure[:recent][:end],
      configure[:previous][:start], configure[:previous][:end]
    )
  end

  def self.setup_hash(name, rstart, rend, pstart = nil, pend = nil)
    {
      :name => name,
      :messages => [],
      :recent => {
        :start => rstart,
        :end   => rend
      },
      :previous => {
        :start => pstart,
        :end   => pend
      }
    }
  end

  def self.target_file(target)
    glob_path = sprintf('%s*.%s.mon', CONFIGURE, target)

    target_path = nil
    Dir.glob(glob_path) do |path|
      target_path = path
      break
    end
    target_path
  end

  def initialize(target, name, rstart, rend, pstart = nil, pend = nil)
    @start          = DateTime.now
    @target         = target
    @name           = name
    @recent_start   = rstart
    @recent_end     = rend
    @previous_start = pstart
    @previous_end   = pend

    @messages = {}

    #ObjectSpace.define_finalizer(self, self.class.aging)
  end

  def append(keyword, *message)
    message_text = message.join("\t")
    message_hash = Digest::MD5.hexdigest keyword
    unless @messages[message_hash]
      @messages[message_hash] = {
        :count   => 0,
        :message => keyword,
        :detail  => []
      }
    end
    @messages[message_hash][:count] += 1
    @messages[message_hash][:detail] << message_text
    self
  end

  def aging
    @end = DateTime.now
    new_configure = self.class.setup_hash(
      @name, @start, @end, @recent_start, @recent_end
    )
    new_configure[:messages] = @messages

    File.open(self.class.target_file(@target), 'w') do |file|
      file.write new_configure.to_yaml
    end
  end

end
