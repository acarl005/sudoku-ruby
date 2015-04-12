require_relative 'sudoku'

# board_strings = File.readlines('set-01_sudoku_puzzles.txt')
# solves 14/15 (takes a while)
board_strings = File.readlines('set-02_project_euler_50-easy-puzzles.txt')
# solves 50/50
# board_strings = File.readlines('set-03_peter-norvig_95-hard-puzzles.txt')
# solves 48/95
# board_strings = File.readlines('set-04_peter-norvig_11-hardest-puzzles.txt')
# solves 8/11

board_strings.each_with_index do |board_string, i|
  game = Sudoku.new(board_string.chomp)
  puts i
  game.solve
  puts game
end


