# encoding: utf-8

class RankingIterator < ActiveResource::Base
  include Enumerable

  self.logger = Logger.new "#{Rails.root.to_s}/log/#{Rails.env}.log"

  INPUT_PATH = "#{Rails.root.to_s}/data/ranking"

  attr_accessor :title, :limit


  def initialize(type_of_ranking, target = Movie)
    contents = YAML.load_file "#{INPUT_PATH}/#{type_of_ranking}.yml"

    @title = contents[:display]

    @items = contents[:set].map do |element|
      item = target.active.where(:id => element[:id]).first
      next nil if item.blank?

      class << item
        attr_accessor :number_for_ranking
      end
      item.number_for_ranking = element[:number]
      item
    end.select{|item| item}

  rescue Exception => e
    logger.warn e
  end

  def each
    return to_enum(:each) unless block_given?

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
end
