module CommentsHelper

  def comment_image_link_small(item)
    link_to(image_tag('icons/comment.png', options={:style => "height: 15px; width: 15px;"}), item.class.to_s == 'Blog' ? blog_path(item) : forum_path(item))
  end
end
