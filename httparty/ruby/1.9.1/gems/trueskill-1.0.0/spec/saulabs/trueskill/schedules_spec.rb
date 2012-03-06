# -*- encoding : utf-8 -*-
require File.expand_path('spec/spec_helper.rb')

describe "Schedules" do
  
  before :each do
    @factor = TrueSkill::Factors::Prior.new(25.0, (25/3.0)**2, Gauss::Distribution.new)
    @step = TrueSkill::Schedules::Step.new(@factor, 0)
  end
  
  it "should do something" do
    @step.visit
  end
  
end
