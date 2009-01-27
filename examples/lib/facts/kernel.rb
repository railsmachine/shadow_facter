require 'shadow_facter'

namespace :kernel do
  fact :name do
    exec "uname -s"
  end

  fact :release do
    exec "uname -r"
  end

  fact :version do
    facts(:kernel)[:release].to_s.split('.')[0]
  end
end
