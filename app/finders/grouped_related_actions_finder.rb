class GroupedRelatedActionsFinder

  def self.find_by_action_ids(action_ids)

    grouped_related_ids = {}
    action_ids.each do |action_id|
      grouped_related_ids[action_id] = []
    end

    relations = ActionRelatedAction.where(source_id: action_ids)
    action_ids.each do |search_id|
      mach_relations = relations.select do |relation|
        relation.source_id == search_id
      end

      grouped_related_ids[search_id] += mach_relations.pluck(:target_id)
    end

    relations = ActionRelatedAction.where(target_id: action_ids)
    action_ids.each do |search_id|
      mach_relations = relations.select do |relation|
        relation.target_id == search_id
      end

      grouped_related_ids[search_id] += mach_relations.pluck(:source_id)
    end

    all_related_action_ids = grouped_related_ids.map do |action_id, related_ids|
      related_ids
    end.flatten.uniq

    all_related_actions = Action.where(id: all_related_action_ids)

    grouped_related_actions = {}
    grouped_related_ids.each do |search_id, related_action_ids|
      grouped_related_actions[search_id] = all_related_actions.select do |action|
        related_action_ids.include?(action.id)
      end
    end

    grouped_related_actions
  end

end