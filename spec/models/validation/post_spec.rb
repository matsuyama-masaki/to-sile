require 'rails_helper'

RSpec.describe Post, type: :model do
  # FactoryBotでユーザーを作成
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーション' do
    context '正常系' do
      it '書籍投稿で有効な属性の場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, :book, user: user)
        
        # 有効であること
        expect(post).to be_valid
      end
      
      it '動画投稿で有効な属性の場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, :video, user: user)
        
        # 有効であること
        expect(post).to be_valid
      end
    end
    
    context 'タイトルのバリデーション' do
      it 'タイトルが空の場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, title: '', user: user)
        # バリデーションを実行
        post.valid?

        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:title]).to include('を入力してください')
      end
      
      it 'タイトルが30文字を超える場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, title: 'a' * 31, user: user)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:title]).to include('は30文字以内で入力してください')
      end
      
      it 'タイトルが30文字ちょうどの場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, title: 'a' * 30, user: user)
        
        # 有効であること
        expect(post).to be_valid
      end
    end
    
    context 'レビュー本文のバリデーション' do
      it 'レビュー本文が空の場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, review_text: '', user: user)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:review_text]).to include('を入力してください')
      end
      
      it 'レビュー本文が1000文字を超える場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, review_text: 'a' * 1001, user: user)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:review_text]).to include('は1000文字以内で入力してください')
      end
      
      it 'レビュー本文が1000文字ちょうどの場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, review_text: 'a' * 1000, user: user)
        
        # 有効であること
        expect(post).to be_valid
      end
    end
    
    context '動画URLのバリデーション' do
      it '動画投稿でvideo_urlが空の場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, :video, video_url: '', user: user)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:video_url]).to include('を入力してください')
      end
      
      it '書籍投稿でvideo_urlが空でも有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, :book, video_url: '', user: user)
        
        # 有効であること
        expect(post).to be_valid
      end
    end
    
    context '画像のバリデーション' do
      it '書籍投稿で画像が添付されていない場合、無効であること' do
        # 画像を添付せずに書籍投稿を作成
        post = FactoryBot.build(:post, :book, user: user)
        # 画像が添付されていれば、削除する
        post.image.detach if post.image.attached?
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:image]).to include('を入力してください')
      end
      
      it '動画投稿で画像が添付されていなくても有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, :video, user: user)

        # 有効であること
        expect(post).to be_valid
      end
      
      # it '書籍投稿で5MBを超える画像の場合、無効であること' do
      #   post = FactoryBot.build(:post, :book, user: user)
        
      #   # 大きなファイルをモック
      #   large_file = double('file')
      #   allow(large_file).to receive(:byte_size).and_return(6.megabytes)
      #   allow(large_file).to receive(:content_type).and_return('image/jpeg')
      #   allow(large_file).to receive(:attached?).and_return(true)
        
      #   post.image.attach(large_file)
      #   post.valid?
        
      #   expect(post).to be_invalid
      #   expect(post.errors[:image]).to include('のサイズは5MB以下にしてください')
      # end
      
      # it '書籍投稿で対応していないファイル形式の場合、無効であること' do
      #   post = FactoryBot.build(:post, :book, user: user)
        
      #   # 対応していないファイル形式をモック
      #   invalid_file = double('file')
      #   allow(invalid_file).to receive(:byte_size).and_return(1.megabyte)
      #   allow(invalid_file).to receive(:content_type).and_return('application/pdf')
      #   allow(invalid_file).to receive(:attached?).and_return(true)
        
      #   post.image.attach(invalid_file)
      #   post.valid?
        
      #   expect(post).to be_invalid
      #   expect(post.errors[:image]).to include('は JPEG, JPG, PNG, GIF 形式のみアップロード可能です')
      # end
    end
    
    context '評価のバリデーション' do
      it '評価が空の場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, rating: nil, user: user)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # 以下のメッセージが表示されること
        expect(post.errors[:rating]).to include('を選択してください')
      end
      
      it '評価が1の場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, rating: 1, user: user)

        # 有効であること
        expect(post).to be_valid
      end
      
      it '評価が5の場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, rating: 5, user: user)

        # 有効であること
        expect(post).to be_valid
      end
    end
    context 'ユーザーのバリデーション' do
      it 'ユーザーが紐付いていない場合、無効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, user: nil)
        # バリデーションを実行
        post.valid?
        
        # 無効であること
        expect(post).to be_invalid
        # エラーが存在すること
        expect(post.errors[:user]).to be_present
      end
      
      it 'ユーザーが存在する場合、有効であること' do
        # FactoryBotの投稿を作成
        post = FactoryBot.build(:post, user: user)

        # 有効であること
        expect(post).to be_valid
      end
    end
  end
end
