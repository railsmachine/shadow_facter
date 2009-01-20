require 'facter'

# To use the module helpers, 'extend ShadowFacter'.
# Modules that extend ShadowFacter behave like standard Facter plugins. Automatically
# namespaces the fact names based on the containing module name. Example, the RubyFacts
# module prefixs all facts with "ruby_" in raw puppet.

module ShadowFacter
  
  # Returns lower case module name without "Facts" and appended with "_".
  
  def prefix
    to_s.downcase.gsub("facts", "_")
  end
  
  # Defines a fact in Facter using a value or block. Can be confined with a hash.
  #
  # Examples:
  #   fact :tea, "oolong"
  #   fact :tea, "puerh", {:season => "winter"}
  #   fact :uptime, exec("uptime")
  #   fact(:rand) { rand }
  
  def fact(key, value=nil, confine_args={}, &block)
    name = key.to_s
    facter_key =  prefix + name
    
    block = lambda { value.to_s } unless block_given?
    Facter.add(facter_key) do 
      confine confine_args unless confine_args.empty?
      setcode block
    end
  end
  
  # Delegates to Facter and provides ModName.factname.
  
  def method_missing(name, *args)
    facter_name = prefix + name.to_s
    return Facter.method_missing(facter_name.to_sym, args)
  end

  # System execute helper.
  
  def exec(command)
    Facter::Util::Resolution.exec(command)
  end

end




