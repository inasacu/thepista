module BlogsHelper
  # Link to a blog (default is by name).
  def blog_link(text, blog = nil, html_options = nil)
    if blog.nil?
      blog = text
      text = blog.name
    elsif blog.is_a?(Hash)
      html_options = blog
      blog = text
      text = blog.name
    end
    # We normally write link_to(..., blog) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), blog, html_options)
  end
end
