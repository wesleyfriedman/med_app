class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.integer :trial_id
      t.string :disease_name
      t.integer :max_age
      t.integer :min_age
      t.float :lat
      t.float :lon
      t.integer :distance

      t.timestamps
    end
  end
end
