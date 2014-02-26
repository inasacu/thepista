# == Schema Information
#
# Table name: sports
#
#  id              :integer          not null, primary key
#  name            :string(50)
#  description     :text
#  icon            :string(40)
#  points_for_win  :float            default(3.0)
#  points_for_lose :float            default(0.0)
#  points_for_draw :float            default(1.0)
#  created_at      :datetime
#  updated_at      :datetime
#  player_limit    :integer          default(150)
#

class Sport < ActiveRecord::Base

	has_many :cups
	has_many :groups
	has_many :markers

	validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
	validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
	validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

	# variables to access
	attr_accessible :name, :points_for_win, :points_for_draw, :points_for_lose, :player_limit, :description, :icon

	def self.sport_name
		find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
	end  

	def self.get_sport_name
		self.select('name').order('name')
	end

	# MOBILE
    def self.get_all
      #Rails.cache.clear
      sport_hash = Rails.cache.fetch("sports") do
        self.select([:id, :name]).map { |c| {:id => c.id, :name => c.name} }
      end
      return sport_hash
    end

end
