class CreateTasks < ActiveRecord::Migration[5.1]
  def change
  	create_table :tasks do |t|
      t.string :name
      t.string :due_date
      t.string :description
      t.string :user_id
    end
  end
end
