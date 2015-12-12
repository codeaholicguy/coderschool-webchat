class AddSeenToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :seen, :boolean, :default => false
  end
end
