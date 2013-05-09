# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  archive    :boolean          default(FALSE)
#

class Conversation < ActiveRecord::Base
  has_many :messages, :order => :created_at
end
