class CreateCompletedThreesRounds < ActiveRecord::Migration[6.0]
  def change
    create_table :completed_threes_rounds do |t|
      t.integer :user_id, null: false
      t.integer :score, null: false
      t.timestamps null: false
    end
    add_index :completed_threes_rounds, :user_id
    add_index :completed_threes_rounds, :created_at
  end
end
