class ChangeGoogleIDtoString < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :google_id
    add_column :users, :google_id, :string
  end
end
