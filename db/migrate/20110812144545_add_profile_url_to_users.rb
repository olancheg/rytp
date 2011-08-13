class AddProfileUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_url, :string
  end

  def self.down
    remove_column :users, :profile_url
  end
end
