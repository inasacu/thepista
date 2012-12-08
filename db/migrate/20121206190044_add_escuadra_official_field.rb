class AddEscuadraOfficialField < ActiveRecord::Migration
  def up
		add_column	:escuadras,			:official,		:boolean,		:default => false
  end

  def down
  end
end
