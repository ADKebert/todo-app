class AddTimeSensitiveToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :time_sensitive, :integer, default: 0
  end
end
