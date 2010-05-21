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
  def blog_link_item(text, blog = nil, html_options = nil)
    if blog.nil?
      blog = text
      text = blog.name
    elsif blog.is_a?(Hash)
      html_options = blog
      blog = text
      text = blog.name
    end        
    text = label_name(:wall)
    text = sanitize(blog.item.name)  unless blog.item_type.nil?    
    link_to(text, blog, html_options)
  end
end
