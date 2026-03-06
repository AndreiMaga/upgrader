- [Concepts](#concepts)
- [Usage](#usage)
- [Modules](#modules)
  - [Common](#common)
    - [Ai](#ai)
      - [Steps](#steps)
        - [*`ai:changes`*](#aichanges)
    - [Changelog](#changelog)
      - [Steps](#steps-1)
        - [*`changelog`*](#changelog-1)
      - [Behaviours](#behaviours)
        - [*`title`*](#title)
    - [Git](#git)
      - [Steps](#steps-2)
        - [*`git:create`*](#gitcreate)
        - [*`git:commit`*](#gitcommit)
      - [Behaviours](#behaviours-1)
        - [*`branch_name`*](#branch_name)
    - [Gitlab](#gitlab)
      - [Steps](#steps-3)
        - [*`gitlab:mr`*](#gitlabmr)
  - [Ruby](#ruby)
    - [Bundle](#bundle)
      - [Steps](#steps-4)
        - [*`bundle:update`*](#bundleupdate)
        - [*`bundle:install`*](#bundleinstall)
      - [Behaviours](#behaviours-2)
        - [*`skip_changes`*](#skip_changes)
    - [Rspec](#rspec)
      - [Steps](#steps-5)
        - [*`rspec`*](#rspec-1)
    - [Rubocop](#rubocop)
      - [Steps](#steps-6)
        - [*`rubocop`*](#rubocop-1)
        - [*`rubocop:fix`*](#rubocopfix)
    - [Ruby-version](#ruby-version)
      - [Steps](#steps-7)
        - [*`ruby-version`*](#ruby-version-1)
        - [Files supported](#files-supported)
      - [Behaviours](#behaviours-3)
        - [*`version`*](#version)


# Concepts

*Modules* are self contained pieces of code, they can be modified by behaviors and they expose 'steps'.  
*Steps* are methods exposed by modules, they usually are in the form 'module:step', but they can also be just the name of the module (ex: changelog)

# Usage

Check out `config/config.template.yml` for an example of how to setup projects and then just run

```
bundle exec ruby lib/upgrader.rb
```

# Modules
## Common

### Ai

#### Steps

##### *`ai:changes`*

Analyses gem version changes using an AI adapter and reports breaking changes.

### Changelog

#### Steps

##### *`changelog`*

Will add a changelog file to the `changelog/unreleased` folder, with the contents.

#### Behaviours

##### *`title`*

The title of the changelog.

### Git

#### Steps

##### *`git:create`*

- checkout main
- perform a hard reset
- clean the branch
- create a branch with a changelog


##### *`git:commit`*

- adds all changes
- commits


#### Behaviours

##### *`branch_name`*

The branch name is created like this `<timestamp>_<branch_prefix>`

### Gitlab

#### Steps

##### *`gitlab:mr`*

Will push the branch and will open a webpage to create the MR.

## Ruby

### Bundle

#### Steps

##### *`bundle:update`*

Runs `bundle update` and can show you the differences in the lockfile.

##### *`bundle:install`*

Runs `bundle install`.

#### Behaviours

##### *`skip_changes`*

Set to true if you don't want to see the changes

### Rspec

#### Steps

##### *`rspec`*

Will run `rspec` and if it fails, it will stop the execution.

### Rubocop

#### Steps

##### *`rubocop`*

Will run `rubocop` and if it finds any offenses, it will stop the execution.

##### *`rubocop:fix`*

Will run `rubocop -a` and will fail if the offenses corrected are not the same as offenses found. This happens when some offenses require -A to be fixed.

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


#### Behaviours

##### *`version`*

Setting the version will skip the prompt to input it.

