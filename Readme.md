# Upgrader

# Why?
I can't be asked doing all of this every 2 weeks to keep stuff upgraded  

# Usage

Check out `config/config.yml` for an example of how to setup projects and then just run

```
bundle exec ruby lib/upgrader.rb
```

# Modules

## Git

### Available steps

#### `git:create`
- checkout main
- perform a hard reset
- clean the branch
- create a branch with a changelog

#### `git:commit`
- adds all changes
- commits

## Bundle

### Available steps

#### `bundle:update`
Runs `bundle update` and allows to see the changes to dependencies
