class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.timestamps
      t.string :title
      t.text :description
    end
  end
end
