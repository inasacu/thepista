module InvitationsHelper
  def invitation_icon(invitation)
    image_tag("icons/email_add.png", :class => "icon")
  end
end
