class AddSearchScript < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute <<-SQL
    
    CREATE VIEW searches AS
    
    SELECT  users.id AS searchable_id, users.name AS term, users.description as term2, users.company as term3, 
    CAST ('User' AS varchar) AS searchable_type 
    FROM users 
    where users.archive = false
    
    UNION 
    
    SELECT  groups.id AS searchable_id, groups.name AS term, groups.description as term2, groups.second_team as term3,
    CAST ('Group' AS varchar) AS searchable_type 
    FROM groups
    where groups.archive = false
    
    UNION 
    
    SELECT  schedules.id AS searchable_id, schedules.concept AS term, sports.name as term2, markers.name as term3, 
    CAST ('Schedule' AS varchar) AS searchable_type 
    FROM schedules, groups, sports, markers
    where schedules.archive = false
    and schedules.group_id = groups.id
    and groups.sport_id = sports.id
    and groups.marker_id = markers.id
    
    UNION 
    
    SELECT cups.id AS searchable_id, cups.name AS term, cups.description as term2, sports.name as term3,
    CAST ('Cup' AS varchar) AS searchable_type 
    FROM cups, sports
    where cups.archive = false
    and cups.sport_id = sports.id  
         
    UNION 
    
    SELECT challenges.id AS searchable_id, challenges.name AS term, challenges.description as term2, sports.name as term3,
    CAST ('Challenge' AS varchar) AS searchable_type 
    FROM challenges, cups, sports
    where challenges.archive = false
    and challenges.cup_id = cups.id
    and cups.sport_id = sports.id 
         
    UNION 
    
    SELECT venues.id AS searchable_id, venues.name AS term, venues.description as term2, markers.name as term3,
    CAST ('Venue' AS varchar) AS searchable_type 
    FROM venues, markers
    where venues.archive = false
    and venues.marker_id = markers.id
    
    SQL

    
  end

  def self.down
    # ActiveRecord::Base.connection.execute <<-SQL
    #   DROP VIEW searches
    # SQL
  end
end