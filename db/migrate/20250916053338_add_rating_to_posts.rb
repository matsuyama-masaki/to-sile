class AddRatingToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :rating, :integer, default: 1
    add_index :posts, :rating
  end
end
