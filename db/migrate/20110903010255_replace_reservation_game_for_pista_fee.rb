class ReplaceReservationGameForPistaFee < ActiveRecord::Migration
  def self.up
    rename_column   :installations,       :fee_per_game,          :fee_per_pista
    rename_column   :reservations,        :fee_per_game,          :fee_per_pista
  end

  def self.down
  end
end
