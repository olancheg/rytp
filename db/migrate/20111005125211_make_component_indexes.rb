class MakeComponentIndexes < ActiveRecord::Migration
  def self.up
    # favouries
    remove_index :favourites, :poop_id
    remove_index :favourites, :user_id
    add_index :favourites, [:poop_id, :user_id]

    # votes
    remove_index :votes, :poop_id
    remove_index :votes, :user_id
    add_index :votes, [:poop_id, :user_id]

    # role associations
    remove_index :role_associations, :role_id
    remove_index :role_associations, :user_id
    add_index :role_associations, [:role_id, :user_id]
  end

  def self.down
    # favouries
    add_index :favourites, :poop_id
    add_index :favourites, :user_id
    remove_index :favourites, [:poop_id, :user_id]

    # votes
    add_index :votes, :poop_id
    add_index :votes, :user_id
    remove_index :votes, [:poop_id, :user_id]

    # role associations
    add_index :role_associations, :role_id
    add_index :role_associations, :user_id
    remove_index :role_associations, [:role_id, :user_id]
  end
end
