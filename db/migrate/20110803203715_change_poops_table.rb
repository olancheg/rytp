class ChangePoopsTable < ActiveRecord::Migration
  def self.up
    rename_column :poops, :is_approved, :approved
    rename_column :poops, :rate, :rating

    remove_column :poops, :author

    add_column :poops, :user_id, :integer
    add_index :poops, :user_id
  end

  def self.down
    rename_column :poops, :approved, :is_approved
    rename_column :poops, :rating, :rate

    add_column :poops, :author, :string

    remove_index :poops, :user_id
    remove_column :poops, :user_id
  end
end
