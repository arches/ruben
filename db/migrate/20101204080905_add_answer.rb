class AddAnswer < ActiveRecord::Migration
  def self.up
    add_column :questions, :answer, :string
  end

  def self.down
    remove_column :questions, :answer
  end
end
