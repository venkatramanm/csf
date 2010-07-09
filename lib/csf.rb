# To change this template, choose Tools | Templates
# and open the template in the editor.

module ConstraintSolver
  autoload :ConstraintViolation ,'csf/constraint_violation'
  autoload :ProcConstraint ,'csf/constraint_violation'
  autoload :AbstractConstraint ,'csf/constraint_violation'
  autoload :Problem ,'csf/problem'
  autoload :Solver , 'csf/solver'
  autoload :Variable , 'csf/variable'
  autoload :VariableAssignment , 'csf/variable'
  autoload :IntegerVariable , 'csf/variable'
  autoload :NoMoreValuesToTry , 'csf/variable'
  autoload :Checkpoint , 'csf/variable'
end
