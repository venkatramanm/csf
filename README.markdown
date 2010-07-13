# A simple framework to solve constraint satisfaction problems
This framework includes what you need to solve constraint satisfaction problems. 
To learn more about constraint satisfaction problems see link:http://en.wikipedia.org/wiki/Constraint_satisfaction_problem 

## How it works (an analogy)
Think of a combination lock with n digits, how would you guess the lock sequence? You would pretty much need  to go from 0 0 0 to 9 9 9. however if you knew that the sum of the digits is 7, You can easily exclude several of the choices as invalid. This is the basic principle followed. 

* You define your problem.
* register variables (with their domain) and constraints. 
* Instantiate a solver for your problem
* solver.next_solution can be called as many times as the number of solutions you need. 
 
## Solver Pseudo code for some basic understanding
for each variable in unassigned variables
  for each value in pruned domain of variable
    assign variable = value 
    check constraints for violation passing (current_variable, assigned_variables, unassigned_variables) 
    # Constraints could prune unassigned variables to avoid unnecessary searches. 
    if a constraint is violated (Throwing constraint violation exception) 
      if move values to try 
        try next value in domain
      else 
        move last_assigned_variable from assigned_variables back to unassigned_variables to try untried values of this variable
      end
    else 
      move variable to assigned_variables from unassigned_variables
    end
  end
end


## Example
### Finding integer solutions to  x + y = 6, domain(x) = [0,1,2,3,4,5] , domain(y) = [0,1,2,3,4,5]
* Creating the problem
 -
 problem = ConstraintSolver::Problem.new 
 -
* Registering problem variables and constraints
 -
    problem.variables = [ConstraintSolver::IntegerVariable.new("x",0,5),ConstraintSolver::IntegerVariable.new("y",0,5)]
    problem.add_constraint do |variable_being_assigned,assigned_variables,un_assigned_variables| 
      target_sum = 6
      target_sum -= variable_being_assigned.value 
      assigned_variables.each do |av|
        target_sum -= av.value
      end

      if target_sum < 0
        raise ConstraintSolver::ConstraintViolation.new
      elsif (un_assigned_variables.empty?)
        if (target_sum > 0)
          raise ConstraintSolver::ConstraintViolation.new
        end
      else
        # remove all values in domains of unassigned variables that are greater than target_sum
        un_assigned_variables.each do |uv|
          uv.domain.reject! do |value_in_domain|
            value_in_domain > target_sum
          end
        end
      end
    end
 -

* Create solver for the problem
 solver = ConstraintSolver::Solver.new(problem) 
 
* finding next solution 
 solver.next_solution

## Other examples
Other examples may be found by browsing the tests folder. 



