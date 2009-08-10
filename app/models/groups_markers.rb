class GroupsMarkers < ActiveRecord::Base

  # record a marker join
  def self.join_marker(group, marker)
    create(:group_id => group.id, :marker_id => marker.id) if self.exists?(marker, group)
  end  
  
  # Return true if the match exist
  def self.exists?(marker, group)
    find_by_group_id_and_marker_id(group, marker).nil?
  end
end