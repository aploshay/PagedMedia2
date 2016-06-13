module PagedMedia
  class ContainerPresenter

    def initialize(container)
      @container = container
    end

    def title
      @container.title
    end

    def metadata
      # TODO Add more metadata fields when they are defined
    end

    def table_of_contents
      @container.cont_array.to_json if @container.respond_to?('cont_array')
    end

    def related_files
      # TODO How to use methods in or like CurationConcerns::WorkShowPresenter to display member file_sets?
    end

  end
end