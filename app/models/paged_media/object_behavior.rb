# Behaviours for all models
# match before/after Booleans
module PagedMedia::ObjectBehavior

  # builds descendents hash, continuing as long as classes filter matches
  # filter on optional class or array of classes, if provided
  # return descendents hash
  def descendents_tree(*classes)
    relationship_tree(:members, :itself, classes)
  end

  def descendents_tree_ids(*classes)
    relationship_tree(:members, :id, classes)
  end

  def ancestors_tree(*classes)
    relationship_tree(:member_of, :itself, classes)
  end

  def ancestors_tree_ids(*classes)
    relationship_tree(:member_of, :id, classes)
  end

  # FIXME: add boolean for stopping at first match?
  def relationship_tree(relationship_method, object_method, classes)
    process_list = self.send(relationship_method).to_a
    process_list.select! { |m| m.class.in?(classes) } unless classes.empty?
    process_list.inject({}) do |h, m|
      h[m.send(object_method)] = m.relationship_tree(relationship_method, object_method, classes)
      h
    end
  end

  # builds list of descendents, walking descendents tree and listing something
  # if it matches the classes filter, or classes filter is empty and it is
  # a terminal node
  def descendents_list(*classes)
    relationship_list(:members, :itself, classes, false)
  end

  def descendents_list_ids(*classes)
    relationship_list(:members, :id, classes, false)
  end

  # build list of ancestors, walking ancestry tree and listing something
  # if it matches the classes filter (or classes filter is empty and it is a
  # terminal node)
  def ancestors_list(*classes)
    relationship_list(:member_of, :itself, classes, true)
  end

  def ancestors_list_ids(*classes)
    relationship_list(:member_of, :itself, classes, true)
  end

  #FIXME: add boolean for continuing past match?
  def relationship_list(relationship_method, object_method, classes, continue_after)
    process_list = self.send(relationship_method).to_a
    process_list.inject([]) do |a, m|
      a << m.send(object_method) if classes.empty? || m.class.in?(classes)
      if classes.empty? || (!m.class.in?(classes) || continue_after)
        a += m.relationship_list(relationship_method, object_method, classes, continue_after)
      end
      a
    end
  end

end
