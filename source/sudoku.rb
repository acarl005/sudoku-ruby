
class Sudoku
  attr_reader :board
  def initialize(board_string)
    @board = []
    board_string.each_char.with_index do |char, index|
      @board << Cell.new(index, char.to_i)
    end
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

  def find_unique(cell_array)
    possibilities = cell_array.map(&:possibilities)
    flat = possibilities.flatten
    flat.each do |number|
      if flat.count(number) == 1
        unique_number = number
        unique_cell = cell_array.find do |cell|
          cell.possibilities.include?(unique_number)
        end
        unique_cell.possibilities = [unique_number]
        solve_cell(unique_cell)
      end
    end
  end

  def try_solve_cell(cell)
    cells_in_column(cell.column)
      .map(&:num)
      .compact
      .each do |number|
        cell.possibilities.delete(number)
      end
    cells_in_row(cell.row)
      .map(&:num)
      .compact
      .each do |number|
        cell.possibilities.delete(number)
      end
    cells_in_box(cell.box)
      .map(&:num)
      .compact
      .each do |number|
        cell.possibilities.delete(number)
      end
    solve_cell(cell) if cell.possibilities.length == 1
  end

  def solve_cell(cell)
    cell.num = cell.possibilities.pop
    update_relatives(cell)
  end

  def update_relatives(cell)
    cells_in_row(cell.row).each do |relative|
      relative.possibilities.delete(cell.num)
    end
    cells_in_column(cell.column).each do |relative|
      relative.possibilities.delete(cell.num)
    end
    cells_in_box(cell.box).each do |relative|
      relative.possibilities.delete(cell.num)
    end
  end

  def solved?
    numbers = @board.map(&:num)
    !numbers.include?(nil)
  end

  def check_individuals
    @board.each do |cell|
      if !cell.num
        try_solve_cell(cell)
      end
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

  def solve
    counter = 0
    until solved?
      check_individuals
      scan_groups
      counter += 1
      break if counter == 50
    end
  end

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
      display = cell.num || "#{cell.possibilities}"
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
      display = cell.num || "-"
      string.sub!(/X/, display.to_s)
    }
    string
  end
end


class Cell
  attr_reader :row, :box, :column
  attr_accessor :num, :possibilities

  def initialize(pos, num)
    pos = pos.to_s(9)
    pos = pos.rjust(2, "0")

    num == 0 ? @num = nil : @num = num

    @row = pos[0].to_i
    @column = pos[1].to_i
    @box = get_box(pos)
    @possibilities = (1..9).to_a if !@num
    @possibilities ||= []
  end

  def get_box(pos)
    pos_vert = pos.to_i / 30
    pos_hor = pos[1].to_i / 3
    [ [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8] ][pos_vert][pos_hor]
  end
end

# practice_cell = Cell.new(52, 2)
# game = Sudoku.new("-3-5--8-45-42---1---8--9---79-8-61-3-----54---5------78-----7-2---7-46--61-3--5--")
# puts game.solve
# puts game.find_unique(game.cells_in_row(0))
