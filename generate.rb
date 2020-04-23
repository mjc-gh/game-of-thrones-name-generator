require 'calyx'
require 'yaml'

ADJECTIVES = YAML.load_file('./data/adjectives.yml')
LOCATIONS  = YAML.load_file('./data/locations.yml')
SUBJECTS   = YAML.load_file('./data/subjects.yml')

class GameNameGenerator < Calyx::Grammar
  start '{adjective} {subject} {prep} {location}'

  adjective *ADJECTIVES
  location *LOCATIONS
  prep *%w[of in from]
  subject *SUBJECTS
end

name_gen = GameNameGenerator.new

5.times do
  puts name_gen.generate
end
