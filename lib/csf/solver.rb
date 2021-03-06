# To change this template, choose Tools | Templates
# and open the template in the editor.

module ConstraintSolver
  class Solver
    
    attr_accessor :problem
    attr_accessor :assigned_variables , :unassigned_variables

    def initialize(problem)
      self.problem = problem
      self.assigned_variables = []
      self.unassigned_variables = []
      problem.variables.each do |var|
        unassigned_variables.push(VariableAssignment.new(var))
      end
      create_check_points
    end

    def next_solution
      begin
        backtrack
        solve_variables
        return to_hash(assigned_variables)
      rescue NoMoreValuesToTry =>e
        return nil
      end
    end

    def solve_variables
      while !unassigned_variables.empty?
        sort_unassigned_variables
        next_variable_to_solve = unassigned_variables.pop
        timer_trace("#{self.class.name}:solve_variable_block") do
          begin
            solve_variable(next_variable_to_solve)
            assigned_variables.push(next_variable_to_solve)
          rescue NoMoreValuesToTry => e
            unassigned_variables.push(next_variable_to_solve)
            backtrack(e)
          end
        end
      end
    end


  private
    def solve_variable(variable_assignment)
      while !variable_assignment.domain.empty?
        begin
          create_check_points
          try_next_value(variable_assignment)
          return
        rescue ConstraintViolation=>e
          variable_assignment.invalidate
          clear_check_points
        end
      end
      raise NoMoreValuesToTry.new(variable_assignment.variable.id)
    end

    def try_next_value(variable_assignment)
      sort_domain(variable_assignment,assigned_variables,unassigned_variables)
      timer_trace("#{self.class.name}.try_next_value") do
        sum_domain_length_after_firing_constraints = unassigned_variables.reduce(0) do |sum,uv|
          sum + uv.domain.length
        end

        begin
          sum_domain_length_before_firing_constraints = sum_domain_length_after_firing_constraints
          problem.constraints.each do |c|
            c.propagate(variable_assignment,assigned_variables,unassigned_variables)
          end
          sum_domain_length_after_firing_constraints = unassigned_variables.reduce(0) do |sum,uv|
            sum + uv.domain.length
          end
        end until (sum_domain_length_after_firing_constraints == sum_domain_length_before_firing_constraints)
      end
    end

    def backtrack(e = nil)
      timer_trace("#{self.class.name} backtrack") do
        last_solved_variable = assigned_variables.pop
        if (last_solved_variable) then
          last_solved_variable.invalidate
          clear_check_points
          unassigned_variables.push(last_solved_variable)
        elsif (e != nil)
          raise e
        end
      end
    end

    def create_check_points
      timer_trace("#{self.class.name} create_check_points") do
        unassigned_variables.each do |v|
          v.create_checkpoint
        end
      end
    end

    def clear_check_points
      timer_trace("#{self.class.name} clear_check_points") do
        unassigned_variables.each do |v|
          v.clear_checkpoint
        end
      end
    end

    def default_sort_unassigned_variables(un_assigned_variables_array)
      un_assigned_variables_array.sort! do |pa1,pa2|
        ret = 0
        l1 = pa1.domain.length
        l2 = pa2.domain.length
        if l1 < l2
          ret = 1
        elsif l1 > l2
          ret = -1
        else
          if (pa1.variable.respond_to?(:<=>)) then
            ret = pa1.variable <=> pa2.variable
          else
            ret = pa1.variable.id.to_s <=> pa2.variable.id.to_s
          end
        end
        ret
      end
    end
    def sort_domain(variable_assignment,assigned_variables,unassigned_variables)
      if problem.respond_to?(:sort_domain) then
        problem.send(:sort_domain,variable_assignment,assigned_variables,unassigned_variables)
      end
    end
    def sort_unassigned_variables
      timer_trace("#{self.class.name} sort_unassigned_variables") do
        if problem.respond_to?(:sort_unassigned_variables) then
          problem.send(:sort_unassigned_variables,unassigned_variables)
        else
          default_sort_unassigned_variables(unassigned_variables)
        end
      end
    end

    def to_hash(assignments)
      problem.to_hash(assignments)
    end
  end

end
