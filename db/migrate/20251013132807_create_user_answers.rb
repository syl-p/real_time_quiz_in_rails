class CreateUserAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :user_answers do |t|
      t.timestamps
      t.belongs_to :user
      t.belongs_to :game
      t.belongs_to :choice
      t.belongs_to :question

      t.index [ :user_id, :question_id, :game_id ], unique: true
    end
  end
end
