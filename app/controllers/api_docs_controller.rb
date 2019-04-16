class ApiDocsController < ApplicationController


  def self.create_document_modules

    base_path_name = "#{Rails.root}/app/docs"
    Pathname.glob("#{base_path_name}/**/*.rb").map do |pathname|

      name = pathname.to_path.gsub(base_path_name, '').gsub('.rb', '')
      module_name = name.split('/').inject do |str, path_part_str|
        next if path_part_str.blank?
        str + "::#{path_part_str.camelize}"
      end

      Module.const_get(module_name)
    end
  end

  def index

    self.class.create_document_modules.each do |doc_module|
      next unless doc_module.class == Module

      self.class.include doc_module
    end

    classes = [self.class].freeze
    render json: Swagger::Blocks.build_root_json(classes)

  end
end
