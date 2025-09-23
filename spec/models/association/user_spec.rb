require 'rails_helper'

RSpec.describe User, type: :model do
  describe "アソシエーション" do
    # FactoryBotのユーザを作成
    let(:user) { create(:user) }

    context "postsとの関連" do
      it "has_manyアソシエーションが設定されていること" do
        # userのpostsアソシエーションを取得
        association = User.reflect_on_association(:posts)
        # has_manyが設定されていること
        expect(association.macro).to eq :has_many
      end

      it "dependent: :destroyが設定されていること" do
        # userのpostsアソシエーションを取得
        association = User.reflect_on_association(:posts)
        # アソシエーションにdependent: :destroyの設定されていること
        expect(association.options[:dependent]).to eq :destroy
      end

      it "userに紐づくpostを取得できること" do
        # 投稿を作成
        post = create(:post, user: user)
        
        # userに紐づくpostを取得できること
        expect(user.posts).to include(post)
        # 取得したpostの数が1件であること
        expect(user.posts.count).to eq 1
      end

      it "userが削除されると関連するpostsも削除されること" do
        # 投稿を2つ作成（1つだと不完全な実装でも通ってしまう可能性があるので、より確実な2つを作成）
        create(:post, user: user)
        create(:post, user: user)
        
        # userを削除すると関連するpostsも削除されること
        expect { user.destroy }.to change { Post.count }.by(-2)
      end
    end

    context "commentsとの関連" do
      it "has_manyアソシエーションが設定されていること" do
        # userのcommentsアソシエーションを取得
        association = User.reflect_on_association(:comments)
        # has_manyが設定されていること
        expect(association.macro).to eq :has_many
      end

      it "dependent: :destroyが設定されていること" do
        # userのcommentsアソシエーションを取得
        association = User.reflect_on_association(:comments)
        # アソシエーションにdependent: :destroyの設定されていること
        expect(association.options[:dependent]).to eq :destroy
      end

      it "userに紐づくcommentを取得できること" do
        # 他のユーザーと投稿を作成
        other_user = create(:user)
        post = create(:post, user: other_user)
        # テスト対象のユーザーがコメントを作成
        comment = create(:comment, user: user, post: post)
        
        # userからcommentを取得できること
        expect(user.comments).to include(comment)
        # 取得したcommentの数が1件であること
        expect(user.comments.count).to eq 1
      end

      it "userが削除されると関連するcommentsも削除されること" do
        # 他のユーザーと投稿を作成
        other_user = create(:user)
        post = create(:post, user: other_user)
        # テスト対象のユーザーがコメントを作成
        create(:comment, user: user, post: post)
        create(:comment, user: user, post: post)
        
        # userが削除すると関連するcommentsも削除されること
        expect { user.destroy }.to change { Comment.count }.by(-2)
      end
    end
  end
end
