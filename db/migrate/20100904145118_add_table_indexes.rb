class AddTableIndexes < ActiveRecord::Migration
  # def self.up
  #   add_index     :roles,             [:name, :authorizable_type, :authorizable_id],  :name => "index_roles_on_name_and_authorizable_type_and_authorizable_id"
  #   add_index     :roles_users,       [:user_id],                                     :name => "index_roles_users_on_user_id"
  #   add_index     :blogs,             [:item_id, :item_type],                         :name => "index_blogs_on_item"
  #       
  #   add_index     :groups,            [:archive],                                     :name => "index_groups_on_archive"
  #   add_index     :users,             [:archive],                                     :name => "index_users_on_archive"
  #   add_index     :challenges,        [:archive],                                     :name => "index_challenges_on_archive"
  #   
  #   add_index     :users,             [:id],                                          :name => "index_users_on_id"
  #       
  #   # add_index     :groups_users,      [:user_id],                                     :name => "index_groups_users_on_user_id"
  #   # add_index     :groups_users,      [:group_id],                                    :name => "index_groups_users_on_group_id"
  #   # add_index     :challenges_users,  [:user_id],                                     :name => "index_challenges_users_on_user_id"
  # end
  # 
  # def self.down
  #   remove_index     :roles,             :name => "index_roles_on_name_and_authorizable_type_and_authorizable_id"
  #   remove_index     :roles_users,       :name => "index_roles_users_on_user_id"
  #   remove_index     :blogs,             :name => "index_blogs_on_item"
  #       
  #   remove_index     :groups,            :name => "index_groups_on_archive"
  #   remove_index     :users,             :name => "index_users_on_archive"
  #   remove_index     :challenges,        :name => "index_challenges_on_archive"
  #   
  #   remove_index     :users,             :name => "index_users_on_id"
  #   
  #   # remove_index     :groups_users,      :name => "index_groups_users_on_user_id"
  #   # remove_index     :groups_users,      :name => "index_groups_users_on_group_id"
  #   # remove_index     :challenges_users,  :name => "index_challenges_users_on_user_id"
  # end
end


# rake db:migrate VERSION=20100904024403

# add_index :tagging, [:item_id, :item_type]
# add_index :notes, :user_id
# add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
# add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"
# add_index :follows, ["followable_id", "followable_type"], :name => "fk_followables
# add_index "scorecards", ["group_id"], :name => "index_scorecards_on_group_id"
# add_index "activities", ["item_id", "item_type"], :name => "index_activities_on_item_id_and_item_type"
# add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
# add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
# add_index "comments", ["entry_id"], :name => "index_comments_on_entry_id"
# add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

