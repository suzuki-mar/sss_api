require 'rails_helper'

RSpec.describe SaveServices::Tag, type: :service do

  describe 'execute' do

    let(:service){SaveServices::Tag.new}
    subject{service.execute(target_model, tag_names)}

    context 'タグが未登録の場合' do
      let(:target_model){@target_model}
      let(:tag_names){['タグA', 'タグB']}
      before do
        @target_model = create(:problem_solving)
      end

      it 'タグが作成されている' do
        expect{ subject }.to change(Tag, :count).from(0).to(2)
      end

      context 'target_modelがproblem_solvingの場合' do
        before do
          @target_model = create(:problem_solving)
        end

        it '問題解決のタグ関連付が作成されている' do
          subject
          expect(TagAssociation.where(:problem_solving => @target_model).count).to eq(2)
          expect(TagAssociation.where.not(reframing_id: nil).count).to eq(0)
          expect(TagAssociation.all.count).to eq(2)
        end
      end

      context 'target_modelがreframingの場合' do
        before do
          @target_model = create(:reframing)
        end

        it 'リフレーミングのタグ関連付が作成されている' do
          subject
          expect(TagAssociation.where(:reframing => @target_model).count).to eq(2)
          expect(TagAssociation.where.not(problem_solving: nil).count).to eq(0)
          expect(TagAssociation.all.count).to eq(2)
        end
      end

      context '関連付けられていないモデルの場合' do
        before do
          @target_model = create(:self_care_classification)
        end

        it '例外が発生すること' do
          error_message = 'Tagと関連付けられていないクラスが渡されました:テーブル名self_care_classifications'
          expect{ subject }.to raise_error(ArgumentError, error_message)
        end
      end

    end

    context '一部のタグが登録されているが関連は登録されていない場合' do
      let(:target_model){create(:problem_solving)}
      let(:tag_names){['存在するタグ', '登録するタグ']}

      before do
        create(:tag, name:'存在するタグ')
      end

      it 'タグが作成されている' do
        expect{ subject }.to change(Tag, :count).from(1).to(2)
      end

      it 'タグ関連が作成されている' do
        expect{ subject }.to change(TagAssociation, :count).from(0).to(2)
      end
    end

    context '一部のタグが登録されていて関連付られている場合' do
      let(:target_model){create(:problem_solving)}
      let(:tag_names){['登録するタグ', '存在するタグ']}

      before do
        tag = create(:tag, name:'存在するタグ')

        create(:tag_association, problem_solving:target_model, tag:tag)

        another_document_tag = create(:tag, name:'登録するタグ')
        another_document_model = create(:problem_solving)
        create(:tag_association, problem_solving:another_document_model, tag:another_document_tag)
      end

      it '関連付けられていないタグのみに関連が作成されこと' do
        expect{ subject }.to change(TagAssociation, :count).from(2).to(3)
      end

    end

    context 'すでに登録しているタグ名がなかった場合' do
      let(:target_model){create(:problem_solving)}
      let(:tag_names){['登録するタグ']}

      before do
        tag = create(:tag, name:'削除するタグ')
        create(:tag_association, problem_solving:target_model, tag:tag)
      end

      it '関連付けられていないタグのみに関連が作成されこと' do
        subject
        expect(Tag.only_associated(target_model).pluck(:name)).to eq(["登録するタグ"])
      end

    end

    context 'namesが空の場合は関連してあるタグをすべて削除する' do
      let(:target_model){create(:problem_solving)}
      let(:tag_names){[]}

      before do
        tag = create(:tag, name:'削除するタグ')
        create(:tag_association, problem_solving:target_model, tag:tag)
      end

      it '関連付けられていないタグのみに関連が作成されこと' do
        subject
        expect(Tag.only_associated(target_model)).to eq([])
      end

    end

  end

end
