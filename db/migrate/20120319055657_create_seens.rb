class CreateSeens < ActiveRecord::Migration
  def change
    create_table :seens do |t|

      t.references('movie')
      t.references('author')
      t.date    :date
      t.string  :acondition,:default => ''
      t.text    :comment,   :default => ''
      t.string  :evaluation,:default => ''
      t.boolean :negative,  :default => false

      t.timestamps
    end
  end
end
