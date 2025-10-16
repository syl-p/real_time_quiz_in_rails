class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.timestamps
      t.belongs_to :quiz
      t.belongs_to :user
    end
  end
end
