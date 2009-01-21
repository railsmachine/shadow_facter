#--
# Copyright 2009 Bradley Taylor <bradley@railsmachine.com>
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
# 
#--

require File.dirname(__FILE__) + '/spec_helper.rb'

describe "facts module" do
  it "generates a prefix" do
    TestFacts.prefix.should == "test_"
  end
  
  it "generates namespaced keys" do
    TestFacts.facter_key(:key).should == :test_key
  end
  

  it "sets value using variable" do
    TestFacts.has_fact?(:drink).should be(true)
    TestFacts[:drink].should == "tea"
  end

  it "sets facts from executed system commands" do
    TestFacts.has_fact?(:uname).should be(true)
    TestFacts[:uname].should == `uname`.chomp
  end

  it "sets facts from blocks" do
    TestFacts.has_fact?(:food).should be(true)
    TestFacts[:food].should == "pizza"
  end

  it "namespaces facts in Facter" do
    Facter[:test_food].value.should == "pizza"
  end

  it "confines setting facts" do
    TestFacts.has_fact?(:beer).should be(false)
    TestFacts.has_fact?(:tea).should be(true)
  end
  
  it "generates array of keys" do
    TestFacts.keys.size.should == 4
  end
  
  it "generates a hash of facts" do
    TestFacts.to_hash.size.should == 4
  end
  
  it "generates yaml of facts" do
    require "yaml"
    YAML.load(TestFacts.to_yaml).values.sort.should == TestFacts.to_hash.values.sort
  end
  
  it "generate json of facts" do
    require 'json'
    JSON.parse(TestFacts.to_json).values.sort.should == TestFacts.to_hash.values.sort
  end

end