class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :text, null: false, default: ""
      t.references :author, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
