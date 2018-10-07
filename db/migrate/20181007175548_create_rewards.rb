class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :title
      t.text :description
      t.integer :points

      t.timestamps
    end
    add_attachment :rewards, :pic
  end
end
