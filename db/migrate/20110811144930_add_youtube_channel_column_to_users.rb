class AddYoutubeChannelColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :youtube_channel, :string
    add_column :users, :show_profile_url, :boolean, :default => true
    add_column :users, :use_nickname_instead_of_name, :boolean, :default => false
  end

  def self.down
    remove_column :users, :youtube_channel
    remove_column :users, :show_profile_url
    remove_column :users, :use_nickname_instead_of_name
  end
end
