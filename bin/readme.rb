# frozen_string_literal: true

root = File.expand_path('..', __dir__)

require("#{root}/lib/init/boot.rb")

GSUBS = {
  MODULES: ''
}

@modules = ''

def handle_steps(modul, steps)
  @modules += "#### Steps\n\n"

  steps.each do |step, comment|
    @modules += "##### *`#{modul}"
    @modules += ":#{step}" unless step == 'run'
    @modules += "`*\n\n"
    @modules += "#{comment}\n\n"
  end
end

def handle_behaviours(type, modul)
  return unless Upgrader::Modules.behaviours.dig(type, modul)

  @modules += "##### Behaviours\n\n"

  Upgrader::Modules.behaviours[type][modul].each do |behaviour, value|
    @modules += "###### *`#{behaviour}`*\n\n"
    @modules += "#{value}\n\n"
  end
end

Upgrader::Modules.steps.each do |type, moduls|
  @modules += "## #{type.capitalize}\n\n"

  moduls.each do |modul, steps|
    @modules += "### #{modul.capitalize}\n\n"

    handle_steps(modul, steps)

    handle_behaviours(type, modul)
  end
end

GSUBS[:MODULES] = @modules
contents = File.read("#{root}/bin/readme/template.readme.md")

GSUBS.each do |key, value|
  contents.gsub!(/<\$#{key}\$>/, value)
end

File.write("#{root}/README.generated.md", contents)
