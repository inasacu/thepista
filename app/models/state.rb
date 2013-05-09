# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  archive    :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base
end
