require 'rails_helper'

RSpec.describe DocumentSearchParameter, type: :parameter do

  describe 'create_find_method_types_by_parameter' do
    context 'target_typeがありでsearch_typeがtext,tagの場合' do
      it do
        parameter = DocumentSearchParameter.new({"text" => 'text', "tag_name" => "tag", "search_types" => [:text, :tag]})
        expect(parameter.search_method_types).to eq([:search_from_text_of_all_type, :search_from_tag_of_all_type])
      end
    end

    context 'target_typeがなしでsearch_typeがtext,tagの場合' do
      it do
        parameter = DocumentSearchParameter.new({"target_type" => "self_care", "text" => 'text', "tag_name" => "tag", "search_types" => [:text, :tag]})
        expect(parameter.search_method_types).to eq([:search_from_text_of_one_type, :search_from_tag_of_one_type])
      end

    end

  end

end
