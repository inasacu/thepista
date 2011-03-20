class ForumsController < ApplicationController
  before_filter :require_user

  before_filter :get_forum, :has_member_access 

  def show
    unless @forum.schedule.nil?
      @schedule = @forum.schedule 
      @group = @schedule.group
      @the_previous = Schedule.previous(@schedule)
      @the_next = Schedule.next(@schedule)
    end  

    @comments = @forum.comments.recent.limit(COMMENTS_PER_PAGE).all  

    if (params[:schedule_id])
      @group = @schedule.group
      @the_roster = @schedule.the_roster     
      @comment = Comment.new
      @comment.body = "there is a roster"

      home_team = {}
    	away_team = {}
    	
      home_team['team'] = "#{@schedule.home_group}:  "
      away_team['team'] = "#{@schedule.away_group}:  "
      home_team['total_players'] = 0
      away_team['total_players'] = 0

      @the_roster.each do |match|
        the_name = match.user.name.split.collect {|i| i.capitalize}.join(' ') 
        if match.type_id == 1
          is_second_team = !(match.group_id > 0)
          if is_second_team
            away_team['players'] = "#{away_team['players']} #{the_name}," 
            away_team['total_players'] += 1
          else
            home_team['players'] = "#{home_team['players']} #{the_name},"  
            home_team['total_players'] += 1 
          end
        end        
      end

      home_team['team'] = "#{@schedule.home_group}: (#{home_team['total_players']}) #{home_team['players']}".chop
      away_team['team'] = "#{@schedule.away_group}: (#{away_team['total_players']}) #{away_team['players']}".chop
      
      @comment = Comment.new(:body => "#{I18n.t(:groups)}\r\n#{home_team['team']}\r\n#{away_team['team']}\r\n")
    end
    
  end

  private

  def get_forum
    unless params[:id].blank?
      @forum = Forum.find(params[:id])
    end
  end

  def has_member_access
    # forum comment
    if @forum
      unless @forum.schedule.blank?
        unless current_user.is_member_of?(@forum.schedule.group)
          redirect_to root_url
          return
        end
      end    
    end
  end

end

