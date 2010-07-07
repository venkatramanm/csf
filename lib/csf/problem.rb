# To change this template, choose Tools | Templates
# and open the template in the editor.

module ConstraintSolver
  class Problem
    attr_accessor :variables
    attr_accessor :constraints
    def initialize
      self.variables = []
      self.constraints = []
    end

    #  add_constraint do |working_variable_assignment,assigned_variables,un_assigned_variables|
    #     ...
    #  end
    def add_constraint(&constraint)
      constraints.push(constraint)
    end
    
  end


  
end
