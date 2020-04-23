require 'sinatra'
require_relative './lib/game_name_generator'

helpers do
  def generate_with(generator_class, max_length: 32)
    gen = generator_class.new

    loop do
      text = gen.generate

      return text if text.size <= max_length
    end
  end
end

get '/' do
  if params[:alliterative] == 'on'
    @game_name = generate_with(AlliterativeGameNameGenerators.random_generator)
  else
    @game_name = generate_with(GameNameGenerator)
  end

  haml :index
end
