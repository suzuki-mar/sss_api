require 'rails_helper'

describe SelfCare, :type => :model do

  describe 'log_date_time' do

    it 'amなら0時' do
      self_care = build(:self_care, log_date:Date.today, am_pm: :am)
      expected_date_time = DateTime.now.change(hour: 0)
      expect(self_care.log_date_time).to eq(expected_date_time)
    end

    it 'pmなら13時' do
      self_care = build(:self_care, log_date:Date.today, am_pm: :pm)
      expected_date_time = DateTime.now.change(hour: 13)
      expect(self_care.log_date_time).to eq(expected_date_time)
    end

  end

  describe 'create_am_pm_by_date' do

    it "11時までならamが帰ること" do
      date_time = DateTime.now.change(hour: 12)
      expect(SelfCare.create_am_pm_by_date_time(date_time)).to eq(:am)
    end

    it "23時までならpmが帰ること" do
      date_time = DateTime.now.change(hour: 23)
      expect(SelfCare.create_am_pm_by_date_time(date_time)).to eq(:pm)
    end

  end

  describe 'recorded_of_specified_time?' do

    before :each do
      create(:self_care, :current_log)
    end

    it '指定した時間の記録が存在するならtrue' do
      expect(SelfCare.recorded_of_specified_time?(DateTime.now)).to be_truthy
    end

    it '指定した時間の記録が存在しないならfalse' do
      expect(SelfCare.recorded_of_specified_time?(DateTime.now - 1.day)).to be_falsey
    end

  end

  describe 'Validation' do
    let(:self_care){build_stubbed(:self_care)}

    it_behaves_like 'log_dateのバリデーション' do
      let(:model){self_care}
    end

    it_behaves_like 'pointのバリデーション' do
      let(:model){build(:self_care)} #update_attributeを使っているのでstubbedは使えない
      let(:attribute_name){:point}
    end

    describe 'reason' do
      example 'nullは許可されない' do
        should validate_presence_of(:reason)
      end 
    end 

    describe 'am_pm' do
      example 'nullは許可されない' do
        should validate_presence_of(:am_pm)
      end
    end

    describe '日付と時刻の組み合わせバリデーション' do

      before do
        create(:self_care, log_date: Date.today, am_pm: :am)
      end

      it '同じ日付と時刻の組み合わせはバリデーションに失敗する' do
        self_care = build(:self_care, log_date: Date.today, am_pm: :am)
        expect(self_care).not_to be_valid
      end

      it '同じ日付だが違う時刻の場合はバリデーションに成功する' do
        self_care = build(:self_care, log_date: Date.today, am_pm: :pm)
        expect(self_care).to be_valid
      end
    end

  end

  describe 'Enum' do 
    it {should define_enum_for(:am_pm).with_values({am: 1, pm: 2})}
  end

  describe 'Table Relation' do 
    it { should belong_to(:self_care_classification ) }
    it { should have_many(:tag_associations).dependent(:nullify) }
    it { should have_many(:actions).dependent(:nullify) }
  end

  describe 'create_save_params_of_date' do

    it '午前中なら現在の日付とamが生成されること' do

      date_time = DateTime.new(2011, 12, 24, 12, 00, 00)
      params = SelfCare.create_save_params_of_date(date_time)

      param_date = params[:log_date]
      expect(param_date.year).to eq(2011)
      expect(param_date.month).to eq(12)
      expect(param_date.day).to eq(24)

      expect(params[:am_pm]).to eq(:am)
    end

    it '午後なら現在の日付とpmが生成されること' do

      date_time = DateTime.new(2011, 12, 24, 13, 00, 00)
      params = SelfCare.create_save_params_of_date(date_time)

      param_date = params[:log_date]
      expect(param_date.year).to eq(2011)
      expect(param_date.month).to eq(12)
      expect(param_date.day).to eq(24)

      expect(params[:am_pm]).to eq(:pm)
    end

  end

  describe 'prev_logs' do

    context '２個前の記録が存在する場合' do
      let!(:target){create(:self_care, log_date:Date.today, am_pm: :am)}
      let!(:prev2_log){create(:self_care, log_date:Date.today - 2.days, am_pm: :pm)}
      let!(:prev1_log){create(:self_care, log_date:Date.yesterday, am_pm: :am)}

      before :each do
        create(:self_care, log_date:Date.today, am_pm: :pm)
      end

      it '２個前の記録を取得する' do
        expect(target.prev_logs).to eq([prev1_log, prev2_log])
      end

    end

    context '1個前しか記録が存在しない場合' do
      let!(:target){create(:self_care, log_date:Date.today, am_pm: :am)}
      let!(:prev1_log){create(:self_care, log_date:Date.yesterday, am_pm: :am)}

      it '1個前だけの記録を取得する' do
        expect(target.prev_logs).to eq([prev1_log])
      end

    end

    context '前の記録が存在しない場合' do
      let!(:target){create(:self_care, log_date:Date.today, am_pm: :am)}

      it 'からの配列を取得する' do
        expect(target.prev_logs).to eq([])
      end

    end

  end

  describe "than_newer?" do

    it '新しければtrue' do
      self_care = create(:self_care, log_date: Date.today, am_pm: :pm)
      compare = create(:self_care, log_date: Date.today, am_pm: :am)

      expect(self_care.than_newer?(compare)).to be_truthy
    end

    it '古ければfalse' do
      self_care = create(:self_care, log_date: Date.today, am_pm: :am)
      compare = create(:self_care, log_date: Date.today, am_pm: :pm)

      expect(self_care.than_newer?(compare)).to be_falsey
    end

  end

  describe 'create_feedback' do

    context 'pointが6以下の場合' do
      it 'ケアが必要' do
        self_care = create(:self_care, log_date: Date.today, am_pm: :pm, point:6)
        self_care.set_up_feedback
        expect(self_care.feedback.is_need_take_care).to be_truthy
      end
    end

    context 'pointが7で直近２回も7以下の場合' do
      it 'ケアが必要' do
        self_care = create(:self_care, log_date: Date.today, am_pm: :pm, point:7)
        create(:self_care, log_date: Date.today, am_pm: :am, point:7)
        create(:self_care, log_date: Date.yesterday, am_pm: :am, point:7)

        self_care.set_up_feedback
        expect(self_care.feedback.is_need_take_care).to be_truthy
      end
    end

    context 'pointが8以上の場合' do
      it 'ケアは不要' do
        self_care = create(:self_care, log_date: Date.today, am_pm: :pm, point:8)
        self_care.set_up_feedback
        expect(self_care.feedback.is_need_take_care).to be_falsey
      end
    end
  end

end
