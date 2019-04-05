require 'rails_helper'

RSpec.describe HasTagModel, type: :model do

  describe 'execute' do

    let(:target_model){create(:problem_solving)}
    subject do
      target_model.save_tags!({'tag_names_text' =>  tag_names_text})
    end

    context 'タグが未登録の場合' do
      let(:tag_names_text){'タグA,タグB'}
      it 'タグが作成されている' do
        expect{ subject }.to change(Tag, :count).from(0).to(2)
      end

      context 'target_modelがproblem_solvingの場合' do
        it '問題解決のタグ関連付が作成されている' do
          subject
          expect(TagAssociation.where(:problem_solving => target_model).count).to eq(2)
          expect(TagAssociation.where.not(reframing_id: nil).count).to eq(0)
          expect(TagAssociation.all.count).to eq(2)
        end
      end

    end

    context '一部のタグが登録されているが関連は登録されていない場合' do
      let(:target_model){create(:problem_solving)}
      let(:tag_names_text){'存在するタグ,登録するタグ'}

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
      let(:tag_names_text){'登録するタグ,存在するタグ'}

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
      let(:tag_names_text){'登録するタグ'}

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
      let(:tag_names_text){[]}

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
