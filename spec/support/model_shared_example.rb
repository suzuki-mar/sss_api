shared_examples "ドラフトアブルな型" do
  it 'complete時はnullは許可されない' do
    should validate_presence_of(check_column_name).on(:completed)
  end

  it 'draft時はnullは許可される' do
    model = create(model_name)
    model.update_attribute(check_column_name, nil)
    expect(model.valid?(:draft)).to be_truthy
  end
end

shared_examples 'log_dateのバリデーション' do
  it '現在の日付は許可する' do
    model.log_date = Date.today
    model.validate
    expect(model.errors.messages.count).to be 0
  end
  it '過去の日付は許可する' do
    model.log_date = Date.yesterday
    model.validate
    expect(model.errors.messages.count).to be 0
  end
  it '未来の日付は許可されない' do
    model.log_date = Date.tomorrow
    model.validate
    expect(model.errors.messages).to have_key(:log_date)
  end
  it 'nullは許可されない' do
    model.log_date = nil
    model.validate
    expect(model.errors.messages).to have_key(:log_date)
  end
end

shared_examples 'log_dateのバリデーション:initializable' do
  it_behaves_like 'log_dateのバリデーション' do
  end

  it '初期化状態の場合はバリデーションを確認しない' do

    raise NotImplementedError.new('HasLogDateModelを実装してください') unless model.class.include?(HasLogDateModel)

    model.send(:execute_initailize_mode)

    model.log_date = Date.tomorrow
    model.validate
    expect(model).to be_valid
  end
end

shared_examples 'pointのバリデーション' do

  it '0より大きい数で10までの場合は許可する' do
    model[attribute_name] = 1
    expect(model).to be_valid
  end
  it '0より大きい数で10までの場合は許可する' do
    model[attribute_name] = 10
    expect(model).to be_valid
  end
  it 'draft時はnilでも許可する' do
    model[attribute_name] = nil
    expect(model).to be_valid(:draft)
  end
  it '10より大きい数は許可しない' do
    model[attribute_name] = 11
    model.validate
    expect(model.errors.messages).to have_key(attribute_name)
  end
  it '正数しか許可しない' do
    model[attribute_name] = -1
    model.validate
    expect(model.errors.messages).to have_key(attribute_name)
  end
  it 'ドラフトではないときはnullは許可されない' do
    model[attribute_name] = nil
    model.validate
    expect(model.errors.messages).to have_key(attribute_name)
  end
end

shared_examples 'pointのバリデーション:initializable' do
  it_behaves_like 'pointのバリデーション' do
  end

  it '初期化状態の場合はバリデーションを確認しない' do
    model.send(:execute_initailize_mode)

    model[attribute_name] = -1
    model.validate
    expect(model).to be_valid
  end
end

# booleanはshoulda-matchers使えない
shared_examples 'is_draftのバリデーション' do
  it 'trueは許可される' do
    model[:is_draft] = true
    expect(model).to be_valid
  end

  it 'falseは許可される' do
    model[:is_draft] = false
    expect(model).to be_valid
  end

  it 'nullは許可されない' do
    model[:is_draft] = nil
    expect(model).not_to be_valid
  end
end