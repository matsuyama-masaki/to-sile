require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'アソシエーション' do
    context 'userとの関連' do
      it 'userに属していること' do
        # postのuserアソシエーションを取得
        association = Post.reflect_on_association(:user)
        # userに属していること
        expect(association.macro).to eq :belongs_to
      end
      
      it 'postに紐づくuserを取得できること' do
        # ユーザ作成
        user = FactoryBot.create(:user)
        # 投稿作成
        post = FactoryBot.create(:post, user: user)
        
        # 作成したオブジェクトが期待するuserと同じであること
        expect(post.user).to eq user
        # postに紐づくuserのnameが存在すること
        expect(post.user.name).to be_present
      end
      
      it 'userに紐づくpostを取得できること' do
        # ユーザ作成
        user = FactoryBot.create(:user)
        # 投稿作成
        post = FactoryBot.create(:post, user: user)
        
        # 作成したオブジェクトが正しく紐づいていること
        expect(user.posts).to include(post)
        # userに紐づくpostが存在すること
        expect(user.posts.count).to eq 1
      end
    end
    
    context 'commentsとの関連' do
      it 'has_manyアソシエーションが設定されていること' do
        # commentsのアソシエーションを取得
        association = Post.reflect_on_association(:comments)
        # has_manyアソシエーションが設定されていること
        expect(association.macro).to eq :has_many
      end
      
      it 'dependent: :destroyが設定されていること' do
        # commentsのアソシエーションを取得
        association = Post.reflect_on_association(:comments)
        # アソシエーションにdependent: :destroyが設定されていること
        expect(association.options[:dependent]).to eq :destroy
      end
      
      it 'postが削除されると、関連するcommentsも削除されること' do
        # ユーザ作成
        user = FactoryBot.create(:user)
        # 投稿作成
        post = FactoryBot.create(:post, user: user)
        
        # Commentで作成するデータ
        comment1 = FactoryBot.create(:comment, 
          post: post,
          user: user,
          comment_text: "テストコメント1"
        )
        comment2 = FactoryBot.create(:comment, 
          post: post,
          user: user,
          comment_text: "テストコメント2"
        )
        # 削除後、２件のコメントが削除されること
        expect { post.destroy }.to change { Comment.count }.by(-2)
      end
    end
  end
end
