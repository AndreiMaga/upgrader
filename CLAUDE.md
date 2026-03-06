# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Upgrader is a Ruby CLI tool that automates multi-step upgrade workflows for Ruby projects (updating Ruby versions, dependencies, running tests, committing, creating MRs). It uses a plugin-based module system with save/resume capabilities.

Ruby 3.4.1 required (see `.ruby-version`).

## Commands

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/modules/ruby/ruby-version/filehandlers/gemfile_spec.rb

# Lint
bundle exec rubocop

# Lint with auto-fix
bundle exec rubocop -a

# Run the tool
bundle exec ruby lib/upgrader.rb [--no-save] [--no-frame]
```

## Architecture

**Entry point:** `lib/upgrader.rb` loads config, iterates projects, runs step sequences with save/resume support.

**Module system (`lib/modules/`):** Plugin architecture where each module registers itself via `BaseModule`. Modules provide steps (actions), behaviors (configuration), and a `run()` method. Steps are referenced in config as `module` or `module:method` (e.g., `git:create`, `rubocop:fix`).

- `modules/base.rb` — Abstract superclass all modules inherit from
- `modules/modules.rb` — Registry that auto-discovers modules via glob, tracks available steps and behaviors
- `modules/common/` — Cross-language modules: git (branching/commits), changelog, gitlab (MR creation)
- `modules/ruby/` — Ruby-specific: bundle, rspec, rubocop, ruby-version

**Ruby version module (`modules/ruby/ruby-version/`):** Has two sub-systems:
- **File handlers** (`filehandlers/`) — Each handler updates a specific file type (Dockerfile, Gemfile, .gitlab-ci.yml, .rubocop.yml, .ruby-version). Uses `BaseFileHandler` with `FILENAME`, `GSUB_PATTERN`, `GSUB_REPLACE` constants. Auto-registers via class inheritance.
- **Managers** (`managers/`) — Abstracts ruby version managers (rbenv, rvm). Provides `list_of_versions`, `install_version`, `run_command`.

**Project class (`lib/project.rb`):** Wraps a project config entry. Routes step strings to module methods, supports per-project behavior overrides.

**Save/resume (`lib/save/save.rb`):** Persists finished steps per project in daily YAML files under `saves/`. Allows resuming interrupted runs.

**Config (`config/config.yml`):** YAML-based. Defines projects with paths, step sequences, and behaviors. See `config/config.template.yml` for structure.

**CLI UI (`lib/ui/cli.rb`):** Wraps `cli-ui` gem for spinners, frames, and graceful exit handling.

**README generator (`bin/readme.rb`):** Auto-generates README.md from module metadata (steps, behaviors).
