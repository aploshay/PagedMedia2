# Generated via
#  `rails generate curation_concerns:work Newspaper`

class CurationConcerns::NewspapersController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = Newspaper
end
