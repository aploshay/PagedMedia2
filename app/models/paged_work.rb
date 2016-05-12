class PagedWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include ::PagedMedia::ObjectBehavior
  include ::PagedMedia::PagedWorkBehavior

  validates :title, presence: { message: 'Your work must have a title.' }
  validates :creator, presence: { message: 'Your work must have an author.' }
end
