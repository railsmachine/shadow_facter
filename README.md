# ShadowFacter

ShadowFacter is a Ruby DSL for Facter, extracted out of the work we at Rails
Machine are doing on [Moonshine](http://blog.railsmachine.com/articles/2009/01/16/moonshine-configuration-management-and-deployment/).

ShadowFacter provides a DSL for creating facts and processing them using Facter. A [binary](http://railsmachine.github.com/shadow_facter/files/bin/shadow_facter.html) is provided to parse facts.


Example:

```
 $ cat examples/lib/facts/kernel.rb
  require 'shadow_facter'

  namespace :kernel do
    fact :name do
      exec "uname -s"
    end

    fact :release do
      exec "uname -r"
    end

    fact :version do
      value(:release).to_s.split('.')[0]
    end
  end
```

Executing this fact:

```
 $ bin/shadow_facter examples/lib/facts/kernel.rb
 kernel_name => Darwin
 kernel_version => 9
 kernel_release => 9.6.0
```

***

Unless otherwise specified, all content copyright &copy; 2014, [Rails Machine, LLC](http://railsmachine.com)
