# Concepts

*Modules* are self contained pieces of code, they can be modified by behaviors and they expose 'steps'.  
*Steps* are methods exposed by modules, they usually are in the form 'module:step', but they can also be just the name of the module (ex: changelog)

# Usage

Check out `config/config.yml` for an example of how to setup projects and then just run

```
bundle exec ruby lib/upgrader.rb
```

# Modules

## Git

### Steps

#### *`git:create`*
- checkout main
- perform a hard reset
- clean the branch
- create a branch with a changelog

#### *`git:commit`*
- adds all changes
- commits

### Behaviours

#### *`branch_prefix`*

The branch is computed like this `<timestamp>_<branch_prefix>`


## Bundle

### Steps

#### *`bundle:update`*
Runs `bundle update` and can show you the differences in the lockfile.

### Behaviours

#### *`skip_changes`*

Set to true if you don't want to see the changes

## Changelog

### Steps

#### *`changelog`*
Will add a changelog file to the `changelog/unreleased` folder, with the contents.


### Behaviours

#### *`title`*
Use this to change the changelog title

## RSpec

### Steps

#### *`rspec`*
Will run `rspec` and if it fails, it will stop the execution.