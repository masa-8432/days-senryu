class CreatePostComments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comments do |t|

      t.timestamps
    end
  end
end
