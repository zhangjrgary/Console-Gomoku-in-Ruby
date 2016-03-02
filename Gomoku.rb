class Player
  attr_reader :symbol

  def initialize( para )
    if para == "O"
      @symbol = "O"
    end
    if para == "X"
      @symbol = "X"
    end
  end

  def nextMove
    # a abstract class
    puts "I am an abstract class"
  end
end

class Human < Player
  # valid fun check the range and not occupied.
  # not occupied to check elements is "." or not
  def inRange(arr)
    if 0 < arr.first.to_i and arr.first.to_i < 15 and 0 < arr.last.to_i and arr.last.to_i < 15
      true
    else
      false
    end
  end

  def isOccupied(arr, board)
    if board[arr[0].to_f][arr[1].to_f].eql?(".")
      true
    else
      false
    end
  end

  def nextMove(obj)
    print "Player #{obj.turn}, make a move (row col): "
    arr = Array.new
    str = gets.chomp()
    arr[0] = str.split(" ").first
    arr[1] = str.split(" ").last
    if inRange(arr) and isOccupied(arr, obj.board)
      puts "Player #{obj.turn} places to row #{arr[0]}, col #{arr[1]}"
      arr
    else
      puts "Invalid input. Try again!"
      self.nextMove(obj)
    end
  end
end

class Computer < Player
  def inRange(arr)
    if arr.first.to_f < 15 and arr.last.to_f < 15
      true
    else
      false
    end
  end

  def isOccupied(arr, board)
    if board[arr[0].to_f][arr[1].to_f].eql?( ".")
      true
    else
      false
    end
  end

  def nextMove(obj)
    # random in range, return two random value
    rRow, rCol = rand(15), rand(15)
    arr = Array[rRow, rCol]
    if inRange(arr) and isOccupied(arr, obj.board)
      puts "Player #{obj.turn} places to row #{arr[0]}, col #{arr[1]}"
      arr
    else
      self.nextMove(obj)
    end
  end
end

class Gomoku
  attr_reader :board, :turn

  def initialize
    @board = Array.new(15) {Array.new(15){"."}}
    @player1 = "O"
    @player2 = "X"
    @turn = @player1
  end

  def isFull
    r, key = 0, 0
    while r < 15
      c = 0
      while c < 15
        if self.board[r][c].eql?(".")
          key += 1
        end
        c += 1
      end
      r += 1
    end
    if key == 0
      true
    else
      #puts "no full"
      false
    end
  end

  def check_win(r, c, symbol)
    current = self.board
    r = r.to_f
    c = c.to_f
    # Test horizontal sequence
    if c < 12
      count = 0
      (0..4).each do |offset|
        if current[r][c + offset] == symbol
          count += 1
        else break
        end
      end
      # Winner found
      return true if count == 5
      #puts "888" if count == 5
    end

    # Test vertical sequence
    if r < 12
      count = 0
      (0..4).each do |offset|
        if current[r + offset][c] == symbol
          count += 1
        else break
        end
      end
      # Winner found
      return true if count == 5
    end

    # Test diagonal-up sequence
    if r > 4 && c < 12
      count = 0
      (0..4).each do |offset|
        if current[r - offset][c + offset] == symbol
          count += 1
        else break
        end
      end
      # Winner found
      return true if count == 5
    end

    # Test diagonal-down sequence
    if r < 12 && c < 12
      count = 0
      (0..4).each do |offset|
        if current[r + offset][c + offset] == symbol
          count += 1
        else break
        end
      end
      # Winner found
      return true if count == 5
    end
    false
    #puts "123"
  end

  def printBoard
    puts "                       1 1 1 1 1"
    puts "   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4"
    row = 0
    while row < 15
      if row < 10
        col = 0
        print " #{row} "
        while col < 15 do
          print @board[row][col]
          print " "
          col += 1
        end
        row += 1
        puts "\n"

      else
        print "#{row} "
        col = 0
        while col < 15 do
          print @board[row][col]
          print " "
          col += 1
        end
        row += 1
        puts "\n"
      end
    end
  end

  def set_board (arr, symbol)
    @board[arr[0].to_f][arr[1].to_f] = symbol
  end

  def set_turn (turn)
    @turn = turn
  end

  def startGame
    print "First player is (1) Computer or (2) Human? "
    p1 = gets.chomp()
    if p1.to_f == 1
      pl1 = Computer.new("O")
      puts "Player O is Computer"
    end
    if p1.to_f == 2
      pl1 = Human.new("O")
      puts "Player O is Human"
    end

    print "Second player is (1) Computer or (2) Human? "
    p2 = gets.chomp()
    if p2.to_f == 1
      pl2 = Computer.new("X")
      puts "Player X is Computer"
    end
    if p2.to_f == 2
      pl2 = Human.new("X")
      puts "Player X is Human"
    end
    self.printBoard

    # game loop
    finish = true
    while finish
      decision = ((self.turn.eql?("O")) ? pl1 : pl2).nextMove(self)
      self.set_board(decision, self.turn)
      self.printBoard

      if self.isFull
        puts "Draw game!"
        finish = false
      end
      if self.check_win(decision[0], decision[1], self.turn)
        puts "Player #{self.turn} wins!"
        finish = false
      end
      if self.turn.eql?("O")
        self.set_turn("X")
      else
        self.set_turn("O")
      end
      # self.set_turn((self.turn == "O") ? pl2.symbol : pl2.symbol)

    end
  end
end

Gomoku.new.startGame