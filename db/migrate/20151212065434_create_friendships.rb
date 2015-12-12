class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, references: :users
      t.references :friend, references: :users
      t.boolean :blocked, :default => false

      t.timestamps null: false
    end
  end
end
