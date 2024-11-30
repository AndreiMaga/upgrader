- [Concepts](#concepts)
- [Usage](#usage)
- [Modules](#modules)
  
# Concepts

*Modules* are self contained pieces of code, they can be modified by behaviors and they expose 'steps'.  
*Steps* are methods exposed by modules, they usually are in the form 'module:step', but they can also be just the name of the module (ex: changelog)

# Usage

Check out `config/config.template.yml` for an example of how to setup projects and then just run

```
bundle exec ruby lib/upgrader.rb
```

# Modules
<$MODULES$>