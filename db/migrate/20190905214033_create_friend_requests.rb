class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.integer :requester_id
      t.integer :requestee_id
      t.boolean :accepted
      t.datetime :accepted_on

      t.timestamps
    end

    add_foreign_key :friend_requests, :users, column: :requester_id
    add_foreign_key :friend_requests, :users, column: :requestee_id
  end
end
