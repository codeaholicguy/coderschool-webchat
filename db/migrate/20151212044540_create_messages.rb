class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :sender, references: :users
      t.references :recipient, references: :users

      t.timestamps null: false
    end
  end
end
