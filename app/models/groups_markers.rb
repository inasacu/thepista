class GroupsMarkers < ActiveRecord::Base
  
  # set_primary_key :group_id
  # set_primary_key :marker_id
  
  # variables to access
  attr_accessible :group_id, :marker_id
  
  # record a marker join
  def self.join_marker(group, marker)
    self.create!(:group_id => group.id, :marker_id => marker.id) if self.exists?(marker, group)
  end  
  
  # Return true if the marker group is nil
  def self.exists?(marker, group)
    find_by_group_id_and_marker_id(group, marker).nil?
  end
end
