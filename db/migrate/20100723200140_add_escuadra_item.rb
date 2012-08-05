class AddEscuadraItem < ActiveRecord::Migration
	def self.up
		add_column        :escuadras,           :item_id,            :integer
		add_column        :escuadras,           :item_type,          :string
	end

	def self.down
	end
end
