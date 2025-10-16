class CreateChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :choices do |t|
      t.timestamps
      t.belongs_to :question
      t.string :label
      t.boolean :correct, default: true
    end
  end
end
