class ResetVotesCountInPoopsTable < ActiveRecord::Migration
  def self.up
    say_with_time "Resetting votes_count column in poops table" do
      Poop.update_all :votes_count => 0
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
