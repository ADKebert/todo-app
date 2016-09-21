class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user
      t.string :title
      t.string :description
      t.datetime :deadline
      t.time :estimated_duration
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
