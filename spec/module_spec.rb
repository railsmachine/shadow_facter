require File.dirname(__FILE__) + '/spec_helper.rb'

describe "facts dsl" do

  before :all do
    @f = facts(:test)
  end

  it "sets namespaces" do
    namespace :test do
      ShadowFacter::Base.current_namespace.should == :test
    end
  end

  it "sets value using variable" do
    @f.has_fact?(:drink).should be(true)
    @f[:drink].should == "tea"
  end

  it "sets facts from methods" do
    @f.has_fact?(:food).should be(true)
    @f[:food].should == "pizza"
  end

  it "namespaces facts in Facter" do
     Facter[:test_food].value.should == "pizza"
   end

   it "confines setting facts" do
     @f.has_fact?(:beer).should be(false)
     @f.has_fact?(:tea).should be(true)
   end

   it "generates array of keys" do
     @f.keys.size.should == 4
   end

   it "generates a hash of facts" do
     @f.to_hash.size.should == 4
   end

   it "generates yaml of facts" do
     require "yaml"
     YAML.load(@f.to_yaml).values.sort.should == @f.to_hash.values.sort
   end

   it "generate json of facts" do
     require 'json'
     JSON.parse(@f.to_json).values.sort.should == @f.to_hash.values.sort
   end

   it "returns namespaces" do
     namespaces.size.should == 1
     namespaces.first.should == :test
   end

   it "reloads keys" do
     orig = @f[:rand]
     @f.reload!
     orig.should_not == @f[:rand]
   end
end