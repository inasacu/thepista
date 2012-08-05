class FullTextSearch1296516029 < ActiveRecord::Migration
  def self.up
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS challenges_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index challenges_fts_idx
    #   ON challenges
    #   USING gin((to_tsvector('spanish', coalesce("challenges"."name", '') || ' ' || coalesce("challenges"."description", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS cups_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index cups_fts_idx
    #   ON cups
    #   USING gin((to_tsvector('spanish', coalesce("cups"."name", '') || ' ' || coalesce("cups"."description", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS groups_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index groups_fts_idx
    #   ON groups
    #   USING gin((to_tsvector('spanish', coalesce("groups"."name", '') || ' ' || coalesce("groups"."description", '') || ' ' || coalesce("groups"."second_team", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS markers_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index markers_fts_idx
    #   ON markers
    #   USING gin((to_tsvector('spanish', coalesce("markers"."name", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS schedules_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index schedules_fts_idx
    #   ON schedules
    #   USING gin((to_tsvector('spanish', coalesce("schedules"."concept", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS sports_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index sports_fts_idx
    #   ON sports
    #   USING gin((to_tsvector('spanish', coalesce("sports"."name", ''))))
    # eosql
    # execute(<<-'eosql'.strip)
    #   DROP index IF EXISTS users_fts_idx
    # eosql
    # execute(<<-'eosql'.strip)
    #   CREATE index users_fts_idx
    #   ON users
    #   USING gin((to_tsvector('spanish', coalesce("users"."name", '') || ' ' || coalesce("users"."description", '') || ' ' || coalesce("users"."company", ''))))
    # eosql
  end

  def self.down
  end
end
