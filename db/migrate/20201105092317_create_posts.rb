class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :theme, null: false
      t.string :text, null: false
      t.boolean :comment_status, null: false, default: false

      t.timestamps
    end
  end
end
