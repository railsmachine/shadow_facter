require File.join(File.dirname(__FILE__) + '/shadow_facter', 'base.rb')

#Return an array of defined namespaces names.
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


