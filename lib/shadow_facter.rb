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
require 'facter'

# To use the module helpers, 'extend ShadowFacter'.
# Modules that extend ShadowFacter behave like standard Facter plugins. Automatically
# namespaces the fact names based on the containing module name. Example, the RubyFacts
# module prefixs all facts with "ruby_" in raw puppet.
module ShadowFacter
  
  # Returns lower case module name without "Facts" and appended with "::".
  def prefix
    to_s.downcase.gsub("facts", "_")
  end
 
  # Returns symbol for key with prefix.
  def facter_key(key)
    (prefix + key.to_s).to_sym
  end

  # Returns a fact value by key. Returns nil if non-existent or not constrained.
  def [](key)
    value(key)
  end

  # Returns a fact value by key. Returns nil if non-existent or not constrained.
  def value(key)
    f = Facter[facter_key(key)]
    f.value unless f.nil?
  end
  
  # Return an array of all of the constrained fact keys.
  def keys
    @keys.uniq.select { |k| !value(k).nil? }
  end

  # Return a boolean on the availability of a fact.
  def has_fact?(key)
    !value(key).nil?
  end
  
  # Return a hash of all of the constrained fact keys and values.
  def to_hash
    keys.inject({}) do |h, k| 
      h[k] = value(k)
      h
    end
  end
  
  # Return yaml of all of the constrained fact keys and values.
  def to_yaml
    require 'yaml'
    to_hash.to_yaml
  end
  
  # Return json of all of the constrained fact keys and values.
  def to_json
    require 'json'
    JSON.pretty_generate to_hash
  end
  
  # Defines a fact in Facter using a value or block. Can be confined with a hash.
  #
  # Examples:
  #   fact :tea, "oolong"
  #   fact :tea, "puerh", {:season => "winter"}
  #   fact(:rand) { rand }
  def fact(key, value=nil, confine_args={}, &block)
    @keys ||= Array.new
    @keys << key

    block = lambda { value.to_s } unless block_given?
    Facter.add(facter_key(key)) do
      confine confine_args unless confine_args.empty?
      setcode block
    end
  end

  # System execute helper.
  def exec(command)
    Facter::Util::Resolution.exec(command)
  end

end




