class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.string :word
      t.string :previous

      t.timestamps null: false
    end
  end
end
