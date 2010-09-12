module ForumsHelper
  # Link to a forum (default is by name).
  def forum_link(text, item = nil, html_options = nil)
    # if forum.nil?
    #   forum = text
    #   text = forum.name
    # elsif forum.is_a?(Hash)
    #   html_options = forum
    #   forum = text
    #   text = forum.name
    # end
    # # We normally write link_to(..., forum) for brevity, but that breaks
    # # text = limit_url_length(text)
    # link_to(h(text), forum, html_options)
    item_name_link(text, item, html_options)
  end
end
