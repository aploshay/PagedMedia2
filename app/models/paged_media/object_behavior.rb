# Behaviours for all models
module PagedMedia::ObjectBehavior

  # builds descendents hash, with objects as keys
  def descendents_tree(*classes)
    relationship_tree(:members, :itself, classes, true)
  end

  # builds descendents hash, with object ids as keys
  def descendents_tree_ids(*classes)
    relationship_tree(:members, :id, classes, true)
  end

  # builds ancestors hash, with objects as keys
  def ancestors_tree(*classes)
    relationship_tree(:member_of, :itself, classes, true)
  end

  # builds ancestors hash, with object ids as keys
  def ancestors_tree_ids(*classes)
    relationship_tree(:member_of, :id, classes, true)
  end

  # abstract method to build a hash of related objects
  # relationship_method: generally :members/:ordered_members, or :member_of
  # object_method: method to return key (:itself, :id, :title, etc)
  # classes: optional array of classes to restrict results to; empty array applies no filter
  # greedy: true to walk entire tree, false to only accept and recur matches
  def relationship_tree(relationship_method, object_method, classes, greedy)
    process_list = self.send(relationship_method).to_a
    process_list.inject({}) do |h, m|
      matched = (classes.empty? || m.class.in?(classes) || classes.map { |c| m.is_a?(c) }.any?)
      if matched
        h[m.send(object_method)] = m.relationship_tree(relationship_method, object_method, classes, greedy)
        h
      elsif greedy
        h.merge(m.relationship_tree(relationship_method, object_method, classes, greedy))
      else
        h
      end
    end
  end

  # list descendents as objects
  def descendents_list(*classes)
    relationship_list(:members, :itself, classes, true)
  end

  # list descendents as ids
  def descendents_list_ids(*classes)
    relationship_list(:members, :id, classes, true)
  end

  # list ancestors as objects
  def ancestors_list(*classes)
    relationship_list(:member_of, :itself, classes, true)
  end

  # list ancestors as ids
  def ancestors_list_ids(*classes)
    relationship_list(:member_of, :id, classes, true)
  end

  # abstract method to build an array
  # relationship_method: generally :members/:ordered_members, or :member_of
  # object_method: method to return key (:itself, :id, :title, etc)
  # classes: optional array of classes to restrict results to; empty array applies no filter
  # greedy: true to walk entire tree, false to only accept and recur matches
  def relationship_list(relationship_method, object_method, classes, greedy)
    process_list = self.send(relationship_method).to_a
    process_list.inject([]) do |a, m|
      matched = (classes.empty? || m.class.in?(classes) || classes.map { |c| m.is_a?(c) }.any?)
      a << m.send(object_method) if matched
      a += m.relationship_list(relationship_method, object_method, classes, greedy) if matched || greedy
    end
  end

end
