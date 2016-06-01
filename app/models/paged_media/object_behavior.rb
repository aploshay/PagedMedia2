# Behaviours for all models
module PagedMedia::ObjectBehavior

  # builds descendents hash, with objects as keys
  def descendents_tree(*classes)
    relationship_tree(:members, :itself, classes)
  end

  # builds descendents hash, with object ids as keys
  def descendents_tree_ids(*classes)
    relationship_tree(:members, :id, classes)
  end

  # builds ancestors hash, with objects as keys
  def ancestors_tree(*classes)
    relationship_tree(:member_of, :itself, classes)
  end

  # builds ancestors hash, with object ids as keys
  def ancestors_tree_ids(*classes)
    relationship_tree(:member_of, :id, classes)
  end

  # abstract method to build a hash of related objects
  # relationship_method: generally :members/:ordered_members, or :member_of
  # object_method: method to return key (:itself, :id, :title, etc)
  # classes: optional array of classes to restrict results to; empty array applies no filter
  def relationship_tree(relationship_method, object_method, classes)
    process_list = self.send(relationship_method).to_a
    process_list.inject({}) do |h, m|
      if classes.empty? || classes.map { |c| m.is_a?(c) }.any?
        h[m.send(object_method)] = m.relationship_tree(relationship_method, object_method, classes)
        h
      else
        h.merge(m.relationship_tree(relationship_method, object_method, classes))
      end
    end
  end

  def cont_array
    array = []
    self.ordered_members.to_a.each do |container|
      if container.class == Container
        array << { "id" => container.id, "title" => container.title, "type" => "Container"}
        children = container.cont_array
        array << children if children.any?
      end
    end
    array
  end

  # list descendents as objects
  def descendents_list(*classes)
    relationship_list(:members, :itself, classes)
  end

  # list descendents as ids
  def descendents_list_ids(*classes)
    relationship_list(:members, :id, classes)
  end

  # list descendents as titles
  def descendents_list_titles(*classes)
    relationship_list(:members, :title, classes)
  end

  # list ancestors as objects
  def ancestors_list(*classes)
    relationship_list(:member_of, :itself, classes)
  end

  # list ancestors as ids
  def ancestors_list_ids(*classes)
    relationship_list(:member_of, :id, classes)
  end

  # list ancestors as ids
  def ancestors_list_titles(*classes)
    relationship_list(:member_of, :title, classes)
  end

  # abstract method to build an array
  # relationship_method: generally :members/:ordered_members, or :member_of
  # object_method: method to return key (:itself, :id, :title, etc)
  # classes: optional array of classes to restrict results to; empty array applies no filter
  def relationship_list(relationship_method, object_method, classes)
    process_list = self.send(relationship_method).to_a
    process_list.inject([]) do |a, m|
      a << m.send(object_method) if classes.empty? || classes.map { |c| m.is_a?(c) }.any?
      a += m.relationship_list(relationship_method, object_method, classes)
    end
  end

end
