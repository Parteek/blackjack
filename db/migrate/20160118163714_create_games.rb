class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :bet_amount
      t.integer :win_amount
      t.string :status, default: 'pending'
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
