require 'shadow_facter'

namespace :network do
  fact :hostname do
    exec "hostname"
  end

end

