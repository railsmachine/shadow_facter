# ShadowFacter allows the simple definition and gathering of facts 
# using Facter[http://reductivelabs.com/projects/facter/]
#
#== Sample facts:
#
#  $ cat examples/lib/facts/kernel.rb 
#  require 'shadow_facter'
#
#  namespace :kernel do
#    fact :name do
#      exec "uname -s"
#    end
#
#    fact :release do
#      exec "uname -r"
#    end
#
#    fact :version do
#      value(:release).to_s.split('.')[0]
#    end
#  end
#
#== Executing this fact:
#
# $ bin/shadow_facter examples/lib/facts/kernel.rb
# kernel_name => Darwin
# kernel_version => 9
# kernel_release => 9.6.0
# $
#


require 'facter'

module ShadowFacter
  class Facts
    
    def initialize(namespace, keys)
      @namespace = namespace
      @keys = keys
    end
    
    # Return a fact value by key. Returns nil if non-existent or not constrained.
    def [](key)
      value(key)
    end

    # Return a fact value by key. Returns nil if non-existent or not constrained.
    def value(key)
      f = Facter[Base.facter_key(@namespace, key)]
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
    
    # Reload facts
    def reload!
      keys.each { |key| Facter[Base.facter_key(@namespace, key)].flush }
    end
    
  end
  
  
  class Base
    class << self
      
      def namespace(name)
        @namespaces ||= Hash.new
        raise "Nested namespaces not supported yet!" unless @current_namespace.nil?
        @current_namespace = name
        yield
        @current_namespace = nil
      end
      
      def namespaces()
        @namespaces.keys
      end

      # Defines a fact in Facter using a value or block. Can be confined with a hash.
      #
      # Examples:
      #   fact :tea, "oolong"
      #   fact :tea, "puerh", {:season => "winter"}
      #   fact(:rand) { rand }
      def fact(key, value=nil, confine_args={}, &block)
        raise "Namespace required!" unless current_namespace
        @namespaces[current_namespace] ||= []
        @namespaces[current_namespace] << key
        block = lambda { value.to_s } unless block_given?
        Facter.add(current_key(key)) do
          confine confine_args unless confine_args.empty?
          setcode block
        end
      end
      
      def facts(namespace)
        ShadowFacter::Facts.new(namespace, @namespaces[namespace])
      end
      
      def current_namespace
        @current_namespace
      end
      
      def current_key(key)
        facter_key(current_namespace, key)
      end
      
      def facter_key(namespace, key)
        (namespace.to_s + "_" + key.to_s).to_sym
      end
    end
  end
end

# Returns known namespaces
def namespaces()
  ShadowFacter::Base.namespaces
end

# Defines a namespace
def namespace(name, &b)
  ShadowFacter::Base.namespace(name, &b)
end

# Defines a fact in Facter using a value or block. Can be confined with a hash.
#
# Examples:
#   fact :tea, "oolong"
#   fact :tea, "puerh", {:season => "winter"}
#   fact(:rand) { rand }
def fact(key, value=nil, confine_args={}, &b)
  ShadowFacter::Base.fact(key, value, confine_args, &b)
end

# Returns an instance of the Facts class for the specified namespace.
def facts(namespace)
  ShadowFacter::Base.facts(namespace)
end

# System execute helper.
def exec(command)
  Facter::Util::Resolution.exec(command)
end
