require 'rails_helper'

RSpec.describe ApiDocsController, type: :controller do

  it 'Swaggerのドキュメントクラスを読み込む' do
    expect(ApiDocsController.create_document_modules).to include(Swagger::ApiDoc)
  end

end
