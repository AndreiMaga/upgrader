- [Concepts](#concepts)
- [Usage](#usage)
- [Modules](#modules)
  - [Git](#git)
    - [Steps](#steps)
      - [*`git:create`*](#gitcreate)
      - [*`git:commit`*](#gitcommit)
    - [Behaviours](#behaviours)
      - [*`branch_prefix`*](#branch_prefix)
  - [Changelog](#changelog)
    - [Steps](#steps-1)
      - [*`changelog`*](#changelog-1)
    - [Behaviours](#behaviours-1)
      - [*`title`*](#title)
  - [Gitlab](#gitlab)
    - [Steps](#steps-2)
      - [*`gitlab:mr`*](#gitlabmr)
  - [Bundle](#bundle)
    - [Steps](#steps-3)
      - [*`bundle:update`*](#bundleupdate)
    - [Behaviours](#behaviours-2)
      - [*`skip_changes`*](#skip_changes)
  - [RSpec](#rspec)
    - [Steps](#steps-4)
      - [*`rspec`*](#rspec-1)



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

The branch name is created like this `<timestamp>_<branch_prefix>`

## Changelog

### Steps

#### *`changelog`*
Will add a changelog file to the `changelog/unreleased` folder, with the contents.


### Behaviours

#### *`title`*
Use this to change the changelog title

## Gitlab

### Steps

#### *`gitlab:mr`*
Will push the branch and will open a webpage to create the MR

## Bundle

### Steps

#### *`bundle:update`*
Runs `bundle update` and can show you the differences in the lockfile.

### Behaviours

#### *`skip_changes`*

Set to true if you don't want to see the changes

## RSpec

### Steps

#### *`rspec`*
Will run `rspec` and if it fails, it will stop the execution.
