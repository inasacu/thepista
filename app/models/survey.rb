# == Schema Information
#
# Table name: surveys
#
#  id           :integer          not null, primary key
#  user_id      :integer          default(0)
#  ubicacion    :integer          default(0)
#  superficie   :integer          default(0)
#  expositor    :integer          default(0)
#  duracion     :integer          default(0)
#  horario      :integer          default(0)
#  cursos       :integer          default(0)
#  demostracion :integer          default(0)
#  concurso     :integer          default(0)
#  organizacion :integer          default(0)
#  expectativa  :integer          default(0)
#  comentario   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


class Survey < ActiveRecord::Base

	belongs_to			:user      

	# variables to access
	attr_accessible :user_id, :ubicacion, :superficie, :expositor, :duracion, :horario, :cursos, :demostracion, :concurso, :organizacion, :expectativa, :comentario

end
