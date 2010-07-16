# To change this template, choose Tools | Templates
# and open the template in the editor.

module ConstraintSolver
  class ConstraintViolation < Exception
  end
  class AbstractConstraint
    def propagate(variable_assignment,assigned_variables,unassigned_variables)
      raise Exception.new("method propagate not implemented")
    end
  end
  class ProcConstraint < AbstractConstraint
    def initialize(&proc)
      @proc = proc
    end

    def propagate(variable_assignment,assigned_variables,unassigned_variables )
      @proc.call(variable_assignment,assigned_variables,unassigned_variables)
    end
  end
end
