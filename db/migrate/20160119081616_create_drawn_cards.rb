class CreateDrawnCards < ActiveRecord::Migration
  def change
    create_table :drawn_cards do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.integer :card_number

      t.timestamps null: false
    end
  end
end
