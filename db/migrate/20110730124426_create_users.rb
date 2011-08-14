class CreateUsers < ActiveRecord::Migration
  def self.up
    drop_table :admins

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :nickname

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
