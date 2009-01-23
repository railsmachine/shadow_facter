require 'facter'

module ShadowFacter
  class Facts
    
    def initialize(namespace, keys)
      @namespace = namespace
      @keys = keys
    end
    
    # Returns a fact value by key. Returns nil if non-existent or not constrained.
    def [](key)
      value(key)
    end

    # Returns a fact value by key. Returns nil if non-existent or not constrained.
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
    
  end
  
  
  class Base
    class << self
      
      def namespace(name)
        @current_namespace ||= []
        raise "Nested namespaces not supported yet!" if @current_namespace.last
        @current_namespace.push name
        yield
        @current_namespace.pop
      end

      # Defines a fact in Facter using a value or block. Can be confined with a hash.
      #
      # Examples:
      #   fact :tea, "oolong"
      #   fact :tea, "puerh", {:season => "winter"}
      #   fact(:rand) { rand }
      def fact(key, value=nil, confine_args={}, &block)
        raise "Namespace required!" unless @current_namespace.last
        @keys ||= Hash.new([])
        @keys[current_namespace] << key
        block = lambda { value.to_s } unless block_given?
        Facter.add(current_key(key)) do
          confine confine_args unless confine_args.empty?
          setcode block
        end
      end
      
      def facts(namespace)
        ShadowFacter::Facts.new(namespace, @keys[namespace])
      end
      
      def current_namespace
        @current_namespace.last
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
