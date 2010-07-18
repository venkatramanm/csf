# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'sample_problem/sudoku'

class SudokuTest < Test::Unit::TestCase
  def test_sudoku
    sudoku = SampleProblem::Sudoku.new
    initial_values  = [
      [nil,7  ,nil,nil,4  ,nil,nil,nil,nil],
      [9  ,4  ,nil,1  ,nil,nil,nil,nil,nil],
      [nil,nil,nil,nil,9  ,3  ,8  ,nil,nil],
      [2  ,3  ,nil,nil,nil,7  ,5  ,nil,nil],
      [4  ,5  ,nil,nil,nil,nil,nil,3  ,2  ],
      [nil,nil,9  ,2  ,nil,nil,nil,1  ,6  ],
      [nil,nil,2  ,8  ,7  ,nil,nil,nil,nil],
      [nil,nil,nil,nil,nil,4  ,nil,6  ,8  ],
      [nil,nil,nil,nil,2  ,nil,nil,5  ,nil]
    ]
    sudoku.register_initial_values(initial_values)
    solver = ConstraintSolver::Solver.new(sudoku)
    solution = solver.next_solution
    print(solution)
  end
  def print(solution)
    (1..9).each do |row|
      row_array = []
      (1..9).each do |col|
        row_array.push(solution[row][col])
      end
      puts row_array.inspect
    end
  end
  
end
