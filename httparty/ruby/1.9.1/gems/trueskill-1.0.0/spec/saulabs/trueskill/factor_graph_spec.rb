# -*- encoding : utf-8 -*-
require File.expand_path('spec/spec_helper.rb')

describe Saulabs::TrueSkill::FactorGraph do
  
  before :each do
    @teams = create_teams
    @skill = @teams.first.first
    @graph = TrueSkill::FactorGraph.new(@teams, [1,2,3])
  end
  
  describe "#update_skills" do
    
    it "should update the mean of the first player in team1 to 30.38345" do
      @graph.update_skills
      @skill.mean.should be_close(30.38345, tolerance)
    end
    
    it "should update the deviation of the first player in team1 to 3.46421" do
      @graph.update_skills
      @skill.deviation.should be_close(3.46421, tolerance)
    end
    
  end
  
  describe "#draw_margin" do
    
    it "should be -0.998291 for diff 0.740466" do
      @graph.draw_margin.should be_close(0.740466, tolerance)
    end
    
  end
  
end

describe Saulabs::TrueSkill::FactorGraph, "two players" do
  
  before :each do
    @teams = [
      [TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0)],
      [TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0)]
    ]
  end
  
  describe 'win with standard rating' do
    
    before :each do
      TrueSkill::FactorGraph.new(@teams, [1,2]).update_skills
    end
    
    it "should change first players rating to [29.395832, 7.1714755]" do
      @teams[0][0].should eql_rating(29.395832, 7.1714755)
    end
  
    it "should change second players rating to [20.6041679, 7.1714755]" do
      @teams[1][0].should eql_rating(20.6041679, 7.1714755)
    end
  
  end
  
  describe 'draw with standard rating' do
    
    before :each do
      TrueSkill::FactorGraph.new(@teams, [1,1]).update_skills
    end
    
    it "should change first players rating to [25.0, 6.4575196]" do
      @teams[0][0].should eql_rating(25.0, 6.4575196)
    end
  
    it "should change second players rating to [25.0, 6.4575196]" do
      @teams[1][0].should eql_rating(25.0, 6.4575196)
    end
  
  end
  
  describe 'draw with different ratings' do
    
    before :each do
      @teams[1][0] = TrueSkill::Rating.new(50.0, 12.5, 1.0, 25.0/300.0)
      TrueSkill::FactorGraph.new(@teams, [1,1]).update_skills
    end
    
    it "should change first players rating to [31.6623, 7.1374]" do
      @teams[0][0].should eql_rating(31.662301, 7.1374459)
    end
  
    it "should change second players mean to [35.0107, 7.9101]" do
      @teams[1][0].should eql_rating(35.010653, 7.910077)
    end
  
  end
  
end

describe Saulabs::TrueSkill::FactorGraph, "two on two" do
  
  before :each do
    @teams = [
      [TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0),TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0)],
      [TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0),TrueSkill::Rating.new(25.0, 25.0/3.0, 1.0, 25.0/300.0)]
    ]
  end
  
  describe 'win with standard rating' do
    
    
  end
  
end
