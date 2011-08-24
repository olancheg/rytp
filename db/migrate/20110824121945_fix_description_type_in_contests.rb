class FixDescriptionTypeInContests < ActiveRecord::Migration
  def self.up
    change_column :contests, :description, :text
  end

  def self.down
    change_column :contests, :description, :string
  end
end
