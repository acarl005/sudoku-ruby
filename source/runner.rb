require_relative 'sudoku'


# board_strings = File.readlines('set-01_sudoku_puzzles.txt')
board_strings = File.readlines('set-02_project_euler_50-easy-puzzles.txt')
# board_strings = File.readlines('set-03_peter-norvig_95-hard-puzzles.txt')
# board_strings = File.readlines('set-04_peter-norvig_11-hardest-puzzles.txt')

board_strings.each_with_index do |board_string, i|
  game = Sudoku.new(board_string.chomp)
  game.solve
  puts i
  puts game.to_p
end

# game = Sudoku.new('1--92----524-1-----------7--5---81-2---------4-27---9--6-----------3-945----71--6')
# game.solve

