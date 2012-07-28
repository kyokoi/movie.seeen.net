class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|

      t.string :name_of_original,   :null => false, :default => ''
      t.string :name_of_japan,      :null => false, :default => ''
      t.string :name_of_japan_kana, :null => false, :default => ''
      t.string :name_of_english,    :null => true,  :default => ''
      t.string :image,              :null => true,  :default => ''
      t.integer :show_time,         :null => false
      t.text    :outline,           :null => false, :default => ''
      t.date :open_date
      t.string :category, :default => ''
      t.boolean :negative,:default => false

      t.timestamps
    end
  end
end
