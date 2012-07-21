class AddPolicemanToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :policeman, :boolean, :default => false
  end

  def self.down
    remove_column :admins, :policeman
  end
end
