require 'calyx'
require 'optparse'
require 'yaml'

require 'active_support/core_ext/string'

ADJECTIVES = YAML.load_file('./data/adjectives.yml')
LOCATIONS  = YAML.load_file('./data/locations.yml')
SUBJECTS   = YAML.load_file('./data/subjects.yml')

PREPS = %w[above at of from under]

class GameNameGenerator < Calyx::Grammar
  start '{singular_phrase}', '{plural_phrase}'

  singular_phrase 'The {adjective} {subject} {prep} {location}'
  plural_phrase '{adjective} {subject.pluralize} {prep} {location}'

  adjective *ADJECTIVES
  location *LOCATIONS
  prep *PREPS
  subject *SUBJECTS
end

AlliterativeGameNameGenerators = ('A'..'Z').each.with_object({}) do |letter, hash|
  filter_blk = ->(str) { str.split(/\s+/).map { |s| s.start_with? letter }.all? }

  filtered_adjectives = ADJECTIVES.filter(&filter_blk)
  filtered_locations  = LOCATIONS.filter(&filter_blk)
  filtered_subjects   = SUBJECTS.filter(&filter_blk)

  next unless filtered_adjectives.any? &&
    filtered_locations.any? &&
    filtered_subjects.any?

  hash[letter] = Class.new(Calyx::Grammar) do
    start '{singular_phrase}', '{plural_phrase}'

    singular_phrase 'The {adjective} {subject} {prep} {location}'
    plural_phrase '{adjective} {subject.pluralize} {prep} {location}'

    adjective *filtered_adjectives
    location *filtered_locations
    prep *PREPS
    subject *filtered_subjects
  end
end

def AlliterativeGameNameGenerators.random_generator
  self.values.shuffle.first
end
