require 'shadow_facter'

module KernelFacts
  extend ShadowFacter

  fact :name do
    exec "uname -s"
  end

  fact :release do
    exec "uname -r"
  end

  fact :version do
    self[:release].to_s.split('.')[0]
  end
end