class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.timestamps
      t.belongs_to :quiz
      t.string :content
    end
  end
end
