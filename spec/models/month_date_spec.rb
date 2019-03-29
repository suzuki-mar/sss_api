require 'rails_helper'

RSpec.describe MonthDate, type: :model do
  describe 'Validation' do

    before :each do
      @month_date = MonthDate.new(year, month)
    end

    context '正常な場合' do
      let(:year){1}

      context '月が1の場合' do
        let(:month){1}
        it 'バリデーションに通る' do
          expect(@month_date.valid).to be_truthy
        end
      end

      context '月が12の場合' do
        let(:month){12}
        it 'バリデーションに通る' do
          expect(@month_date.valid).to be_truthy
        end
      end

    end

    context 'エラーな場合' do
      subject do
        @month_date.valid
        @month_date.error_messages
      end

      describe 'month' do
        let(:year){10000}

        let(:error_message){"月の指定がおかしいです:渡した月:#{month}"}

        context '1より小さい' do
          let(:month){0}
          it 'バリデーションに通らない' do
            expect(subject[:month]).to eq(error_message)
          end
        end

        context '12より多い' do
          let(:month){13}
          it 'バリデーションに通らない' do
            expect(subject[:month]).to eq(error_message)
          end
        end

      end

      describe 'year' do
        let(:month){12}

        context '1より小さい' do
          let(:year){0}
          it 'バリデーションに通らない' do
            expect(subject[:year]).to eq("年の指定がおかしいです:渡した年:#{year}")
          end
        end

      end
    end
  end
end
