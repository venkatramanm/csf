# To change this template, choose Tools | Templates
# and open the template in the editor.

module ConstraintSolver
  class Variable
    attr_accessor  :id,:domain

    def initialize(id, array)
      self.id = id
      self.domain = array
    end

  end

  class IntegerVariable < ConstraintSolver::Variable
    def initialize(name,min,max)
      super(name,(min..max).to_a)
    end
  end

  class NoMoreValuesToTry < Exception
    def initialize(msg = nil)
      super(msg)
    end
  end

  class VariableAssignment
    attr_accessor :variable, :checkpoints
    def initialize(variable)
      self.variable = variable
      self.checkpoints = []
    end

    def create_checkpoint
      checkpoint = nil
      if self.checkpoints.empty?
        checkpoint = Checkpoint.new(variable.domain)
      else
        checkpoint = Checkpoint.new(checkpoints.last.domain)
      end
      self.checkpoints.push(checkpoint)
    end
    def clear_checkpoint
      self.checkpoints.pop
    end

    def value
      checkpoints.last.domain.last
    end

    def domain
      checkpoints.last.domain
    end

    def invalidate
      checkpoints.last.domain.pop
    end
    def attribute
      checkpoints.last.attribute
    end
  end

  class Checkpoint
    attr_accessor :domain
    attr_accessor :attribute
    def initialize(domain)
      self.domain = domain.clone
      self.attribute = {} 
    end
  end

end