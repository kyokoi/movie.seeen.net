# encoding: utf-8

module MyHelper
  def count_ages(matches)
    selected_table = Hash.new
    matches.each do |year, count|
      key_name = (year.to_i * 0.1).floor * 10
      selected_table[key_name] ||= 0
      selected_table[key_name]  += count
    end
    selected_table.sort do |(age1, count1), (age2, count2)|
      age2 <=> age1
    end
  end

  def select_by_ages(matches, age)
    selected = matches.select do |year, count|
      year.to_i >= age && age + 9 >= year.to_i
    end
    selected.sort do |(year1, count1), (year2, count2)|
      year2 <=> year1
    end
  end
end
