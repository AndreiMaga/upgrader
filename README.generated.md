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
## Ruby

### Bundle

#### Steps

##### *`bundle:update`*

Runs `bundle update` and can show you the differences in the lockfile.

##### *`bundle:install`*

Runs `bundle install`.

##### Behaviours

###### *`skip_changes`*

Set to true if you don't want to see the changes

### Rspec

#### Steps

##### *`rspec`*

Will run `rspec` and if it fails, it will stop the execution.

### Ruby-version

#### Steps

##### *`ruby-version`*

Will prompt the user for a ruby version to update to, after that will install the version (if not already installed).
Once the version is installed, it will run the file handlers, these will go through the specified files and update the ruby version inside.

Adding `ruby-version` will automatically run `bundle:install` after it

##### Files supported
- Dockerfile
- Gemfile
- .gitlab-ci.yml
- .rubocop.yml
- .ruby-version


##### Behaviours

###### *`version`*

Setting the version will skip the prompt to input it.

