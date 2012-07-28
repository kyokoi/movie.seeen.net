class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.string :name, :null => false, :default => ''
      t.boolean :attrib,      :default => 0
      t.integer :belong,      :default => 0
      t.integer :order_by,    :default => 0
      t.string  :match_table, :default => ''
      t.boolean :negative,    :default => false

      t.timestamps
    end
  end
end
