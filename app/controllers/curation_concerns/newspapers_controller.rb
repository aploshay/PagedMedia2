# Generated via
#  `rails generate curation_concerns:work Newspaper`

class CurationConcerns::NewspapersController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = Newspaper

  def show
    super
    @cont_json = Newspaper.find(@presenter.id).cont_array.to_json
  end

end
