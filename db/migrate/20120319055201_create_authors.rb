class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|

      t.string :uid,      :null => false, :default => ''
      t.string :name,     :null => false, :default => ''
      t.string :email,    :null => false, :default => ''
      t.string :image,    :null => false, :default => ''
      t.string :provider, :null => false, :default => ''
      t.boolean :negative,:default => 0

      t.timestamps
    end
  end
end
