class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :login
      t.string :password
      t.string :name
      t.boolean :main, :default => false

      t.timestamps
    end

    admin = Admin.new(:name => 'Olancheg', :login => 'olancheg', :password => 'qweqwe')
    admin.main = true
    admin.save
  end

  def self.down
    drop_table :admins
  end
end
