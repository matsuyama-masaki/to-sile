require 'rails_helper'

RSpec.describe Comment, type: :model do
  # ユーザ、投稿を作成
    let(:user) { create(:user) }
    let(:post) { create(:post) }

  describe 'アソシエーション' do
    # コメントを作成
    let(:saved_comment) { create(:comment, user: user, post: post) }  
    
    context 'userとの関連' do
      it 'userに属すること' do
        # commentのuserアソシエーションを取得
        association = Comment.reflect_on_association(:user)
        # userに属していること
        expect(association.macro).to eq :belongs_to
      end

      it 'userアソシエーションが正しく動作すること' do
        # DBから取得したuserがメモリ上のuserと同じであること
        expect(saved_comment.user).to eq(user)
        # DBから取得したuser_idがメモリ上のuser_idと同じであること
        expect(saved_comment.user.id).to eq(user.id)
      end
      
      it 'user経由でcommentsにアクセスできること' do
        # user経由でcommentsにアクセスできること
        expect(user.comments).to include(saved_comment)
      end
    end

    context 'postとの関連' do
      it 'postに属すること' do
        # commentのuserアソシエーションを取得
        association = Comment.reflect_on_association(:post)
        # postに属していること
        expect(association.macro).to eq :belongs_to
      end

      it 'postアソシエーションが正しく動作すること' do
       # DBから取得したpostがメモリ上のpostと同じであること
        expect(saved_comment.post).to eq(post)
        # DBから取得したpost_idがメモリ上のpost_idと同じであること
        expect(saved_comment.post.id).to eq(post.id)
      end

      it 'post経由でcommentsにアクセスできること' do
        # post経由でcommentsにアクセスできること
        expect(post.comments).to include(saved_comment)
      end
    end
  end
end
