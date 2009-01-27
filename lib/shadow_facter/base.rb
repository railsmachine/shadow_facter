# ShadowFacter allows the simple definition and gathering of facts
# using Facter[http://reductivelabs.com/projects/facter/]
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

    # Reload facts in namespace.
    def reload!
      keys.each { |key| Facter[Base.facter_key(@namespace, key)].flush }
    end

  end


  class Base
    class << self

      # Define a namespace.
      def namespace(name)
        @namespaces ||= Hash.new
        raise "Nested namespaces not supported yet!" unless @current_namespace.nil?
        @current_namespace = name
        yield
        @current_namespace = nil
      end

      # Return an array of defined namespaces names.
      def namespaces()
        @namespaces.keys
      end

      # Define a fact in Facter using a value or block. Can be confined with a hash
      # of Facter keys (namespace_key) and value.
      #
      # Examples:
      #   fact :tea, "oolong"
      #   fact :tea, "puerh", {:drinks_season => "winter"}
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

      # Return an instance of the Facts class for the specified namespace.
      def facts(namespace)
        ShadowFacter::Facts.new(namespace, @namespaces[namespace])
      end

      # Construct a namespaced key for using with Facter.
      def facter_key(namespace, key)
        (namespace.to_s + "_" + key.to_s).to_sym
      end
      
      def current_namespace
        @current_namespace
      end

      def current_key(key)
        facter_key(current_namespace, key)
      end
      
      private :current_namespace, :current_key
    end
  end
end

# Return an array of defined namespaces names.
def namespaces()
  ShadowFacter::Base.namespaces
end

# Define a namespace.
def namespace(name, &b)
  ShadowFacter::Base.namespace(name, &b)
end

# Define a fact in Facter using a value or block. Can be confined with a hash
# of Facter keys (namespace_key) and value.
# Examples:
#   fact :tea, "oolong"
#   fact :tea, "puerh", {:drinks_season => "winter"}
#   fact(:rand) { rand }
def fact(key, value=nil, confine_args={}, &b)
  ShadowFacter::Base.fact(key, value, confine_args, &b)
end

# Return an instance of the Facts class for the specified namespace.
def facts(namespace)
  ShadowFacter::Base.facts(namespace)
end

# Execute a system command via Facter.
def exec(command)
  Facter::Util::Resolution.exec(command)
end
