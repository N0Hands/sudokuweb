require 'sinatra'
require_relative './lib/sudoku'

enable :sessions


def random_sudoku
    seed = (1..9).to_a.shuffle + Array.new(81-9,0)
    sudoku = Sudoku.new(seed.join)
    sudoku.solve!
    # sudoku.hide_numbers
    sudoku.to_s.gsub(/0/," ").chars
end

def puzzle(chars)
      chars.map.with_index do |char,index|
        if Random.rand(100)<45
          char
        end
      end
end

get '/' do	
	sudoku = random_sudoku 
	session[:solution] = sudoku
	@current_solution = puzzle(sudoku)
	erb :index
end

get '/solution' do
	@current_solution = session[:solution]
	erb :index
end
