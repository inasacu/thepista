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
    link_to(label_name(:wall), blog, html_options)
  end
end
