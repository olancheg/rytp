class AlterNewsTable < ActiveRecord::Migration
  def self.up
    remove_column :news, :photo
    add_column :news, :user_id, :integer
    add_index :news, :user_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
