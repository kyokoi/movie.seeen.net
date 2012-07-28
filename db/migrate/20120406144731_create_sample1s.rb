class CreateSample1s < ActiveRecord::Migration
  def change
    create_table :sample1s do |t|
      t.string :hoge

      t.timestamps
    end
  end
end
