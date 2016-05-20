# Generated via
#  `rails generate curation_concerns:work PagedMedia`

class CurationConcerns::PagedWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  self.curation_concern_type = PagedWork

  def show
    super
    # @members = find_members()
    @members = PagedWork.find(params[:id]).ordered_members.to_a
  end

  def find_members(*args)
    if args.size > 0
      params[:id] = args[0]
    end
    members = {}
    query = "{!join from=member_ids_ssim to=id}id:" + params[:id]
    search = ActiveFedora::SolrService.instance.conn.select :params => { :q => query, :fl => "id,title_tesim,has_model_ssim" }
    #puts "*******SEARH*******"
    #puts search
    #puts "*******************"
    unless search['response']['numFound'].to_i == 0
      members = search['response']['docs']
    else
      members = {:id => params[:id], :error => 'No members'}
    end
    #FIXME: keep?
    members ||= "[]"
    return members
  end

end
