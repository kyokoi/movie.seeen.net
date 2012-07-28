class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :hoge

      t.timestamps
    end
  end
end
