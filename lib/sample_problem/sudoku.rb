# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'csf'
module SampleProblem
  class Sudoku < ConstraintSolver::Problem
    def initialize
      super()
      @grid = {}
      (1..9).each do |row|
        @grid[row] = {}
        (1..9).each do |col|
          @grid[row][col] = CellVariable.new(row,col)
          variables.push(@grid[row][col])
        end
      end
      constraints.push(GridConstraint.new(self))
      constraints.push(RowColumnConstraint.new(self))
    end
    def grid
      @grid
    end
    def register_initial_values(values = [[]])
      row_no = 0
      values.each do |row|
        row_no += 1
        col_no = 0
        row.each do |cell_value|
          col_no += 1
          if (cell_value)
            @grid[row_no][col_no].domain.reject! do |value|
              value != cell_value
            end
          end
        end
      end
    end
    def to_hash(assignments)
      a_hash = {}
      assignments.each do |assignment|
        cell = assignment.variable
        value = assignment.value
        a_hash[cell.row] = {} unless a_hash.key?(cell.row)
        a_hash[cell.row][cell.col] = value
      end
      a_hash
    end
  end

  class CellVariable < ConstraintSolver::Variable
    attr_accessor :row, :col
    def initialize(row,col)
      super("#{row},#{col}",(1..9).to_a)
      self.row = row
      self.col = col
    end
  end
  class  RowColumnConstraint < ConstraintSolver::AbstractConstraint

    def initialize(problem)
      @problem = problem
    end
    def propagate(variable_assignment,assigned_variables,unassigned_variables)
      cell = variable_assignment.variable
      value = variable_assignment.value
      unassigned_variables.each do |uv|
        an_uc = uv.variable
        an_ucdomain = uv.domain
        if (an_uc.row == cell.row || an_uc.col == cell.col)
          an_ucdomain.reject! do |possible_value|
            possible_value == value
          end
        end
      end
    end
  end
  class  GridConstraint < ConstraintSolver::AbstractConstraint
    def initialize(problem)
      @problem = problem
    end
    def propagate(variable_assignment,assigned_variables,unassigned_variables)
      cell = variable_assignment.variable
      value = variable_assignment.value
      unassigned_variables.each do |uv|
        an_uc = uv.variable
        an_ucdomain = uv.domain
        if (same_grid?(cell,an_uc))
          an_ucdomain.reject! do |possible_value|
            possible_value == value
          end
        end
      end
    end
    def same_grid?(cell1, cell2)
      ( (cell1.row - 1)  / 3  == (cell2.row - 1) / 3) && ( (cell1.col - 1) / 3 == (cell2.col - 1) / 3)
    end
  end
end