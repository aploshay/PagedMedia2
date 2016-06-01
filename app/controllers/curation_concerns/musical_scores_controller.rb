# Generated via
#  `rails generate curation_concerns:work MusicalScore`

class CurationConcerns::MusicalScoresController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = MusicalScore

  def show
    super
    @cont_json = MusicalScore.find(@presenter.id).cont_array.to_json
  end
end
