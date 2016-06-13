module PagedMedia::ContainersControllerBehavior
  extend ActiveSupport::Concern

  included do
    class_attribute :presenter_class
    self.presenter_class = PagedMedia::ContainerPresenter
  end

  def index
    @containers = Container.all
  end

  def show
    @container_presenter = PagedMedia::ContainerPresenter.new(container)
    # TODO Use table_of_contents instead of @cont_json in partials; for now we share the TOC partial with paged works which needs @cont_json
    @cont_json = @container_presenter.table_of_contents
    render locals: { container_presenter: @container_presenter }
  end

  private

  def container
    @container ||= Container.find(params[:id])
    # TODO Use container_solr_document when/if cont_array gets solrized, for now load object to get it
    # @container_solr_document ||= ActiveFedora::Base.load_instance_from_solr(params[:id])
  end

end