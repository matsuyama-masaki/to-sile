class RemoveDefaultFromPostsRating < ActiveRecord::Migration[7.2]
  def change
    change_column_default :posts, :rating, from: 1, to: nil
  end
end
