# Generated via
#  `rails generate curation_concerns:work Newspaper`
class Newspaper < ActiveFedora::Base
  include ::PagedMedia::ObjectBehavior
  include ::PagedMedia::ContainerBehavior
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  validates :title, presence: { message: 'Your work must have a title.' }
end
