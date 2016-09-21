class ChangeEstimatedDurationtoInteger < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :estimated_duration
    add_column :tasks, :estimated_duration, :integer
  end
end
