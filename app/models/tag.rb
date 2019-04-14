class Tag < ApplicationRecord

  validates :name, uniqueness: true, presence: true
  has_many :tag_associations, dependent: :destroy

  scope :only_progress_status, -> (progress_status) { where(progress_status: progress_status) }
  scope :only_associated, -> (document_model) do
    joins(:tag_associations).where("tag_associations.#{document_model.foreign_key_column} = #{document_model.id}")
  end

  class << self
    def create_from_name_list_if_unexists!(names)

      already_exists_names = self.all.pluck(:name)
      create_names = names - already_exists_names

      create_names.each do |name|
        self.create!(name: name)
      end

    end

  end

end