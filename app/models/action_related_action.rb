class ActionRelatedAction < ApplicationRecord

  belongs_to :source, class_name: "Action"
  belongs_to :target, class_name: "Action"

  validate :validate_relation

  def self.has_already_relation_registered(source, target, exclusion = nil)

    # SQLの実行回数をすくなくするためにループでも判定をする
    relations = ActionRelatedAction.where(source_id: source).or(ActionRelatedAction.where(target_id: source))
    relations.any? do |relation|
      # 除外したものと同じ場合はfalseとする
      return false if exclusion.present? && exclusion.id == relation.id

      relation.target_id == target.id || relation.source_id == target.id
    end
  end

  def self.find_by_source_and_target(source, target)
    or_relation = self.where(source: target).where(target: source)
    self.where(source: source).where(target: target).or(or_relation).first
  end

  private
  def validate_relation
    if ActionRelatedAction.has_already_relation_registered(self.source, self.target, self)
      errors.add(:relation, '同じ組み合わせを登録することはできません')
    end

    if self.source_id == self.target_id
      errors.add(:relation, 'source_idとtarget_idを同じものを登録することはできません')
    end

  end

end
