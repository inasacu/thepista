class AddScheduleSendCommentAtField < ActiveRecord::Migration
  def self.up
      add_column      :schedules,       :send_comment_at,        :datetime
  end

  def self.down
  end
end
