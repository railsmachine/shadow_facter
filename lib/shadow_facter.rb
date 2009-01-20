require 'facter'

module ShadowFacter
  
  def prefix
    to_s.downcase.gsub("facts", "_")
  end
  
  def fact(key, value=nil, confine_args={}, &block)
    name = key.to_s
    facter_key =  prefix + name
    
    block = lambda { value.to_s } unless block_given?
    Facter.add(facter_key) do 
      confine confine_args unless confine_args.empty?
      setcode block
    end
  end
  
  def method_missing(name, *args)
    facter_name = prefix + name.to_s
    return Facter.method_missing(facter_name.to_sym, args)
  end

  def exec(command)
    Facter::Util::Resolution.exec(command)
  end

end




