require_relative './lib/game_name_generator'

options = { alliterate: false }

OptionParser.new do |opts|
  opts.banner = "Usage: generate.rb [options]"

  opts.on('-a', '--alliterate', 'Make it alliterative') do |a|
    options[:alliterate] = a
  end
end.parse!

name_gen = options[:alliterate] ?
  AlliterativeGameNameGenerators.random_generator.new :
  GameNameGenerator.new

5.times do
  puts name_gen.generate
end
