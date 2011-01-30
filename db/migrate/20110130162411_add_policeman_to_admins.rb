class AddPolicemanToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :policeman, :boolean, :default => false

    Admin.update_all ['policeman = ?', false]
  end

  def self.down
    remove_column :admins, :policeman
  end
end
