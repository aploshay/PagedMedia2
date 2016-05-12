# Generated via
#  `rails generate curation_concerns:work MusicalScore`
class MusicalScore < ActiveFedora::Base
  include ::PagedMedia::ObjectBehavior
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  validates :title, presence: { message: 'Your work must have a title.' }
end
