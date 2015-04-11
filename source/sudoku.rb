
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

  def find_unique_alg(cell_array)
    possibilities = cell_array.map(&:possibilities)
    flat = possibilities.flatten
    flat.each do |number|
      if flat.count(number) == 1
        unique_number = number
        unique_cell = cell_array.find do |cell|
          cell.possibilities.include?(unique_number)
        end
        unique_cell.num = unique_number
        unique_cell.possibilities.clear
        self.check_individuals
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
    self.check_individuals
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

  def find_unique_row
    (0..8).each do |row|
      find_unique_alg(cells_in_row(row))
    end
  end

  def find_unique_column
    (0..8).each do |column|
      find_unique_alg(cells_in_column(column))
    end
  end

  def solve
    until solved?
      check_individuals
      find_unique_row
      check_individuals
      find_unique_column
    end
    self
  end

  # def to_s!
  #   string = ''
  #   @board.each_slice(27) do |block|
  #     string << "-------------------------------\n"
  #     block.each_slice(9) do |row|
  #       horizontal = row.map do |cell|
  #         number = cell.num
  #         number ||= "#{cell.possibilities}"
  #       end
  #       to_print = '| '
  #       horizontal.each_slice(3) { |section|
  #         to_print << section.join('  ') << ' | '
  #       }
  #       string << to_print + "\n"
  #     end
  #   end
  #   string << "-------------------------------\n"
  # end

  def to_s
    string = ''
    @board.each_slice(27) do |block|
      string << "-------------------------------\n"
      block.each_slice(9) do |row|
        horizontal = row.map do |cell|
          number = cell.num
          number ||= "-"
        end
        to_print = '| '
        horizontal.each_slice(3) { |section|
          to_print << section.join('  ') << ' | '
        }
        string << to_print + "\n"
      end
    end
    string << "-------------------------------\n"
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
    return 0 if pos_vert == 0 && pos_hor == 0
    return 1 if pos_vert == 0 && pos_hor == 1
    return 2 if pos_vert == 0 && pos_hor == 2
    return 3 if pos_vert == 1 && pos_hor == 0
    return 4 if pos_vert == 1 && pos_hor == 1
    return 5 if pos_vert == 1 && pos_hor == 2
    return 6 if pos_vert == 2 && pos_hor == 0
    return 7 if pos_vert == 2 && pos_hor == 1
    return 8 if pos_vert == 2 && pos_hor == 2
  end
end

practice_cell = Cell.new(52, 2)
game = Sudoku.new("-3-5--8-45-42---1---8--9---79-8-61-3-----54---5------78-----7-2---7-46--61-3--5--")
puts game.solve
# puts game.find_unique(game.cells_in_row(0))
