class Search < ActiveRecord::Base
    
  # We want to reference various models
  belongs_to :searchable, :polymorphic => true
  # Eliminate n + 1 query problems
  default_scope :include => :searchable
  
  # Add all fields we want indexed
  index do
    term
    term2
    term3
  end
    
  # Search.new('query') to search for 'query'
  # across searchable models
  def self.new(query)
    query = query.to_s
    return [] if query.empty?
    self.search(query).map!(&:searchable)
  end
    
  # Search records are never modified
  def readonly?; true; end

  # Our view doesn't have primary keys, so we need
  # to be explicit about how to tell different search
  # results apart; without this, we can't use :include
  # to avoid n + 1 query problems
  def hash; [searchable_id, searchable_type].hash; end
  def eql?(result)
    searchable_id == result.searchable_id and
      searchable_type == result.searchable_type
  end
  
end