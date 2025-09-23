require 'rails_helper'

RSpec.describe Comment, type: :model do
  # ユーザ、投稿、コメントのデータを作成
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment, user: user, post: post) }

  describe 'バリデーション' do
    context 'comment_textの存在チェック' do
      it 'comment_textが存在する場合は有効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: 'これはコメントです')
        # 有効であること
        expect(comment).to be_valid
      end

      it 'comment_textがnilの場合は無効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: nil)
        # 無効であること
        expect(comment).not_to be_valid
      end

      it 'comment_textが空文字列の場合は無効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: '')
        # 無効であること
        expect(comment).not_to be_valid
      end

      it 'comment_textが空白のみの場合は無効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: '   ')
        # 無効であること
        expect(comment).not_to be_valid
      end
    end

    context 'comment_textの文字数制限' do
      it '1文字の場合は有効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: 'a')
        # 有効であること
        expect(comment).to be_valid
      end

      it '65535文字の場合は有効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: 'a' * 65535)
        # 有効であること
        expect(comment).to be_valid
      end

      it '65536文字の場合は無効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: 'a' * 65536)
        # 無効であること
        expect(comment).not_to be_valid
        # 以下のメッセージが表示されること
        expect(comment.errors[:comment_text]).to include('は65535文字以内で入力してください')
      end

      it '通常のコメント文字数は有効であること' do
        # コメントを作成
        comment = build(:comment, comment_text: 'これはコメントです。これはコメントです。これはコメントです。')
        # 無効であること
        expect(comment).to be_valid
      end
    end

    context '関連するモデルの存在チェック' do
      it 'userが存在しない場合は無効であること' do
        # コメントを作成
        comment = build(:comment, user: nil)
        # 無効であること
        expect(comment).not_to be_valid
      end

      it 'postが存在しない場合は無効であること' do
        # コメントを作成
        comment = build(:comment, post: nil)
        # 無効であること
        expect(comment).not_to be_valid
      end
    end
  end

  describe '#own_comment?' do
    # コメントを投稿するユーザを作成
    let(:comment_author) { FactoryBot.create(:user) }
    # 他のユーザを作成
    let(:other_user) { FactoryBot.create(:user) }
    # comment_authorが投稿したコメントを作成
    let(:comment) { FactoryBot.create(:comment, user: comment_author) }

    context 'own_comment?をコメント投稿者が呼び出した場合' do
      it 'trueを返すこと（コメント編集できる）' do
        # trueを返すこと
        expect(comment.own_comment?(comment_author)).to be true
      end
    end

    context 'own_comment?を他のユーザーが呼び出した場合' do
      it 'falseを返すこと（コメント編集できない）' do
        # falseを返すこと
        expect(comment.own_comment?(other_user)).to be false
      end
    end

    context 'current_userがnilの場合（ログインしていない場合）' do
      it 'falseを返すこと（コメント編集できない）' do
        # falseを返すこと
        expect(comment.own_comment?(nil)).to be false
      end
    end
  end
end
