

require 'sinatra'
require_relative './lib/sudoku'
require_relative './lib/cell'
require 'sinatra/partial'
require_relative './helpers/application'

enable :sessions

set :partial_template_engine, :erb

set :session_secret, "75677896g76g897v8ni8grddyhg7"

require 'rack-flash'
use Rack::Flash


def random_sudoku
    seed = (1..9).to_a.shuffle + Array.new(81-9,0)
    sudoku = Sudoku.new(seed.join)
    sudoku.solve!
    # sudoku.hide_numbers
    sudoku.to_s.chars #to_s.gsub(/0/," ").
end

def puzzle(sudoku)
    # sudoku = sudoku.dup
  sudoku.map.with_index do |sudoku,index|
    if Random.rand(100)<45
      sudoku
    end
  end
end

# def puzzle(sudoku)
#   a = (0..80).to_a.sample(12)
#   a.each do |index|
#   sudoku[index] = ''
#   end
#   sudoku
# end

# Does chars become a problem later on..? When we introduce the series of arguments to be used for guessing etc?

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  sudoku = random_sudoku
  session[:solution] = sudoku
  session[:puzzle] = puzzle(sudoku)
  session[:current_solution] = session[:puzzle]
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  if @check_solution
    flash[:notice] = "Incorrect values are highlighted in yellow"
  end
  session[:check_solution] = nil
end

get '/reset' do
  session[:solution] = nil
  session[:current_solution] = nil
  session[:last_visit] = nil
  redirect to('/')
end 

get '/' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution] || session[:puzzle]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  # sudoku = random_sudoku 
  # session[:solution] = sudoku
  # @current_solution = puzzle(sudoku)
  erb :index
end

get '/last-visit' do
  "previous visit to homepage: #{session[:last_visit]}"
end

get '/solution' do
  @current_solution = session[:solution]
  @solution = session[:solution]
  @puzzle = session[:solution]
  erb :index
end

post '/' do
  boxes = params["cell"].each_slice(9).to_a
  cells = (0..8).to_a.inject([]) {|memo, i|
    memo += boxes[i/3*3, 3].map{|box| box[i%3*3, 3] }.flatten
  }
  session[:current_solution] = cells.map{|value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/")
end





















