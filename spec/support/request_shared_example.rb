shared_examples "オブジェクトが存在しない場合" do
  it '404エラースオブジェクトが返されること' do
    subject
    json = JSON.parse(response.body)
    expect(json['message']).to eq("#{resource_name} not found")
  end

  it do
    subject
    expect(response.status).to eq 404
  end

end

shared_examples 'スキーマ通りのオブジェクトを取得できること' do

  it do
    subject
    json = JSON.parse(response.body)
    expect(json.keys).to match_array(expected_response_keys)
  end

end