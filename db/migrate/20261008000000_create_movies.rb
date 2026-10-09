class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :rating, null: false
      t.text :description
      t.datetime :release_date, null: false
      t.timestamps
    end
  end
end
