# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'csf'


class CSFTest < Test::Unit::TestCase
  def test_cartesian
    solver = ConstraintSolver::Solver.new(@problem)
    i = 0
    while  (solver.next_solution)
      i += 1
    end
    assert_equal(36, i)
  end
  
  def test_solver_x_plus_y_eq_6
    @problem.add_constraint do |variable_being_assigned,assigned_variables,un_assigned_variables|
      target_sum = 6
      target_sum -= variable_being_assigned.value;
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

    solver = ConstraintSolver::Solver.new(@problem)
    i = 0
    while (solver.next_solution)
      i += 1
    end
    assert_equal(5, i)

  end
  def setup
    @problem = ConstraintSolver::Problem.new
    @problem.variables = [ConstraintSolver::IntegerVariable.new("x",0,5),ConstraintSolver::IntegerVariable.new("y",0,5)]
  end
end
