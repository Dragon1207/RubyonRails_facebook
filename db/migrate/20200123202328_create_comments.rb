class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :post, foreign_key: true
      t.references :author, foreign_key: {to_table: :users}
      t.text :text, null: false

      t.timestamps
    end
  end
end
