# encoding: utf-8

class RankingIterator < ActiveResource::Base
  include Enumerable

  self.logger = Logger.new "#{Rails.root.to_s}/log/#{Rails.env}.log"

  INPUT_PATH = "#{Rails.root.to_s}/data/ranking"

  attr_accessor :title, :limit


  def initialize(type_of_ranking, target = Movie)
    contents = YAML.load_file "#{INPUT_PATH}/#{type_of_ranking.to_s}.yml"
    @title = contents[:display]

    @items = contents[:set].map do |element|
      item = target.new element[:item]

      class << item
        attr_accessor :number_for_ranking

        def force_id(id)
          self.id = id
        end
      end
      item.force_id element[:item]['id']
      item.number_for_ranking = element[:number]
      item
    end
  end

  def count
    @items.count
  end

  def each
    return to_enum(:each) unless block_given?

    return if @items.blank?

    before_number   = nil
    same_rank_items = []
    @items.each do |item|
      if before_number.nil?
        before_number = item.number_for_ranking
        same_rank_items << item
        next
      end

      if before_number.to_i == item.number_for_ranking.to_i
        same_rank_items << item
        next
      end

      yield same_rank_items
      before_number   = item.number_for_ranking
      same_rank_items = [item]
    end

    yield same_rank_items
  end

  def [](point, offset)
    @items[point, offset]
  end

  def rank(element)
    self.each.with_index(1) do |items, rank|
      if items.map{|item| item.id}.include? element.id
        return rank
      end
    end
    nil
  end
end
