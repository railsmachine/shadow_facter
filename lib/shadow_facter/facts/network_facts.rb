require 'shadow_facter'

module NetworkFacts
  extend ShadowFacter

  fact :hostname do
    exec "hostname"
  end

end