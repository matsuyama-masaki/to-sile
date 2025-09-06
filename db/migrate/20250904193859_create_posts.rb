class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :review_text
      t.integer :post_type
      t.integer :category
      t.string :image
      t.string :video_url

      t.timestamps
    end
  end
end
