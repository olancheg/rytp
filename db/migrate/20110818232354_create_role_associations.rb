class CreateRoleAssociations < ActiveRecord::Migration
  def self.up
    create_table :role_associations do |t|
      t.references :user
      t.references :role

      t.timestamps
    end

    add_index :role_associations, :user_id
    add_index :role_associations, :role_id
  end

  def self.down
    drop_table :role_associations
  end
end
