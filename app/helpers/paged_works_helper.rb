module PagedWorksHelper
  include Rails.application.routes.url_helpers
  def format_hash(hash)
      il_contents = ''
      il_contents << content_tag(:li, link_to(hash["title"].to_s, container_path(hash["id"].to_s)), class: 'list-group-item')
      il_contents.html_safe
  end

  def format_array(array, html='')
    ul_contents = '<ul>'
    array.each do |value|
      if value.is_a?(Hash)
        ul_contents += format_hash(value)
      elsif value.is_a?(Array)
        ul_contents += format_array(value)
      else
        Rails.logger.info "Unexpected value in format_array: #{value.inspect}"
        Rails.logger.info "value type: #{value.class.name}"
      end
    end
    ul_contents << '</ul>'
    html << ul_contents
    html.html_safe
  end

end