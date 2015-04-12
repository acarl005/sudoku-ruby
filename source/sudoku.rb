
class Sudoku
  attr_reader :board, :guesses
  def initialize(board_string)
    @board = []
    board_string.each_char.with_index do |char, index|
      @board << Cell.new(index, char.to_i)
    end
    @guesses = 0
  end

  def board_string
    @board.map { |cell| cell.num || '-' }.join
  end

  def cells_in_row(num)
    @board.select do |cell|
      cell.row == num
    end
  end

  def cells_in_column(num)
    @board.select do |cell|
      cell.column == num
    end
  end

  def cells_in_box(num)
    @board.select do |cell|
      cell.box == num
    end
  end

  def adjacent_row_boxes(num)
    if num % 3 == 1
      [
        @board.select { |cell| cell.box == num - 1 },
        @board.select { |cell| cell.box == num + 1 }
      ]
    elsif num % 3 == 0
      [
        @board.select { |cell| cell.box == num + 2 },
        @board.select { |cell| cell.box == num + 1 }
      ]
    else
      [
        @board.select { |cell| cell.box == num - 1 },
        @board.select { |cell| cell.box == num - 2 }
      ]
    end
  end

  def adjacent_column_boxes(num)
    if (0..2).include?(num)
      [
        @board.select { |cell| cell.box == num + 6 },
        @board.select { |cell| cell.box == num + 3 }
      ]
    elsif (3..5).include?(num)
      [
        @board.select { |cell| cell.box == num - 3 },
        @board.select { |cell| cell.box == num + 3 }
      ]
    else
      [
        @board.select { |cell| cell.box == num - 6 },
        @board.select { |cell| cell.box == num - 3 }
      ]
    end
  end

  def solved?
    numbers = @board.map(&:num)
    !numbers.include?(nil)
  end

  def solve
    counter = 0
    until solved?
      check_individuals
      scan_groups
      analyze_possi
      counter += 1
      break if counter == 10
    end
    start_guessing if !solved?
  end

  def check_individuals
    @board.each do |cell|
      if !cell.num
        try_solve_cell(cell)
      end
    end
  end

  def try_solve_cell(cell)
    cells_in_column(cell.column)
      .map(&:num)
      .compact
      .each do |number|
        cell.possi.delete(number)
      end
    cells_in_row(cell.row)
      .map(&:num)
      .compact
      .each do |number|
        cell.possi.delete(number)
      end
    cells_in_box(cell.box)
      .map(&:num)
      .compact
      .each do |number|
        cell.possi.delete(number)
      end
    solve_cell(cell) if cell.possi.length == 1
  end

  def solve_cell(cell)
    cell.num = cell.possi.pop
    update_relatives(cell)
  end

  def update_relatives(cell)
    cells_in_row(cell.row).each do |relative|
      relative.possi.delete(cell.num)
    end
    cells_in_column(cell.column).each do |relative|
      relative.possi.delete(cell.num)
    end
    cells_in_box(cell.box).each do |relative|
      relative.possi.delete(cell.num)
    end
  end

  def scan_groups
    (0..8).each do |row|
      find_unique(cells_in_row(row))
    end
    (0..8).each do |column|
      find_unique(cells_in_column(column))
    end
    (0..8).each do |box|
      find_unique(cells_in_box(box))
    end
  end

  def find_unique(cell_array)
    possi = cell_array.map(&:possi)
    flat = possi.flatten
    flat.each do |number|
      if flat.count(number) == 1
        unique_number = number
        unique_cell = cell_array.find do |cell|
          cell.possi.include?(unique_number)
        end
        unique_cell.possi = [unique_number]
        solve_cell(unique_cell)
      end
    end
  end

  def analyze_possi
    @board.each do |cell|
      if !cell.num
        examine_row_neighboors(cell)
      end
    end
  end

  def examine_row_neighboors(cell)
    boxes_of_interest = adjacent_row_boxes(cell.box)
    remove_these = []
    cell.possi.each do |num|
      boxes_of_interest.each do |box|
        cells_of_interest = box.select do |cell|
          cell.possi.include?(num)
        end
        rows = cells_of_interest.map(&:row).uniq
        if rows.length == 1 && rows[0] == cell.row
          remove_these << num
        end
      end
    end
    remove_these.each { |num| cell.possi.delete(num) }
  end

  def examine_column_neighboors(cell)
    boxes_of_interest = adjacent_column_boxes(cell.box)
    remove_these = []
    cell.possi.each do |num|
      boxes_of_interest.each do |box|
        cells_of_interest = box.select do |cell|
          cell.possi.include?(num)
        end
        columns = cells_of_interest.map(&:column).uniq
        if columns.length == 1 && columns[0] == cell.column
          remove_these << num
        end
      end
    end
    remove_these.each { |num| cell.possi.delete(num) }
  end

  def start_guessing
    guesses = map_guesses(self)
    puts find_correct_guess(guesses)
  end

  def map_guesses(obj)
    obj.board.find { |cell| !cell.num }
                        .possi
                        .map do |num|
                          guess = Guess.new(obj.board_string)
                          guess.guess(num)
                          guess.solve
                          guess
                        end
  end

  def find_correct_guess(guesses)
    guesses.select! { |guess| guess.valid }
    return 'no valid guess' if guesses.empty? || @guesses > 10
    @board = (guesses.find(&:solved?) || self).board
    if !solved?
      more_guesses = []
      guesses.slice(0,3).each { |guess| more_guesses.concat(map_guesses(guess)) }
      find_correct_guess(more_guesses)
    end
  end
  #recursive FTW

  def to_p
    string = <<-BOARD
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
    BOARD
    @board.each { |cell|
      display = cell.num || "#{cell.possi}"
      string.sub!(/X/, display.to_s)
    }
    string
  end

  def to_s
    string = <<-BOARD
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      | X X X | X X X | X X X |
      +-------+-------+-------+
    BOARD
    @board.each { |cell|
      display = cell.num || " "
      string.sub!(/X/, display.to_s)
    }
    string
  end
end


class Guess < Sudoku
  attr_reader :valid
  def initialize(board_string)
    @valid = true
    @board = []
    board_string.each_char.with_index do |char, index|
      @board << Cell.new(index, char.to_i)
    end
    solve
  end

  def find_unique(cell_array)
    possi = cell_array.map(&:possi)
    flat = possi.flatten
    begin
      flat.each do |number|
        if flat.count(number) == 1
          unique_number = number
          unique_cell = cell_array.find do |cell|
            cell.possi.include?(unique_number)
          end
          unique_cell.possi = [unique_number]
          solve_cell(unique_cell)
        end
      end
    rescue
      @valid = false
    end
  end

  def guess(num)
    cell = @board.find { |cell| !cell.num }
    cell.possi = [num]
    solve_cell(cell)
  end

  def solve
    counter = 0
    until solved?
      check_individuals
      scan_groups
      analyze_possi
      counter += 1
      break if counter == 10
    end
  end
end


class Cell
  attr_reader :row, :box, :column
  attr_accessor :num, :possi
  def initialize(str_index, num)
    @num = num == 0 ? nil : num
    @row = str_index / 9
    @column = str_index % 9
    @box = [ [0, 1, 2],
             [3, 4, 5],
             [6, 7, 8] ][row / 3][column / 3]
    @possi = (1..9).to_a if !@num
    @possi ||= []
  end
end

