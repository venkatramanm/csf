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
    
    #  Example
    #  add_constraint(constraint) 
    #  or
    #  add_constraint do |working_variable_assignment,assigned_variables,un_assigned_variables|
    #     ...
    #  end
    def add_constraint(constraint,&constraint_proc)
      if (constraint)
        if block_given? then
          raise Exception.new("Only one of constraint object or block can be passed")
        end
        constraints.push(constraint)
      else
        unless block_given? then
          raise Exception.new("Atleast one of constraint object or block can be passed")
        end
        constraints.push(ProcConstraint.new(&constraint_proc))
      end
    end
    
    def to_hash(assignments)
        a_hash = {}
        assignments.each do |assignment|
          a_hash[assignment.variable.id] = assignment.value
        end
        a_hash
    end
  end


  
end
