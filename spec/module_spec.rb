require File.dirname(__FILE__) + '/spec_helper.rb'

describe "facts module" do
  it "creates existence check" do
    TestFacts.drink?.should be(true)
  end
  
  it "sets value using variable" do
    TestFacts.drink.should == "tea"
  end
  
  it "sets facts from executed system commands" do
    TestFacts.uname.should == `uname`.chomp
  end
  
  it "sets facts from blocks" do
    TestFacts.food.should == "pizza"
  end
  
  it "namespaces facts" do
    Facter.test_food.should == "pizza"
  end
  
  it "confines setting facts" do
    TestFacts.beer?.should be(false)
    TestFacts.tea?.should be(true)
  end
end
