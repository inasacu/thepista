# == Schema Information
#
# Table name: groups_markers
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  marker_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :boolean          default(FALSE)
#

class GroupsMarkers < ActiveRecord::Base
  
  # record a marker join
  def self.join_marker(group, marker)
    self.create!(:group_id => group.id, :marker_id => marker.id, :created_at => Time.now, :updated_at => Time.now) if self.exists?(marker, group)
  end  
  
  # Return true if the marker group is nil
  def self.exists?(marker, group)
    find_by_group_id_and_marker_id(group, marker).nil?
  end
end
