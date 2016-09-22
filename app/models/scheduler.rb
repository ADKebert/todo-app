class Scheduler
  # Helper class for finding best combination of "set_size" elements
  class TaskSet
    def initialize(tasks, set_size, time_block)
      @tasks      = tasks
      @set_size   = set_size
      @time_block = time_block
    end

    def best_of_size
      if @set_size == 1
        pick_one
      else
        @tasks.map { |task| TaskSet.new(@tasks.reject{ |t| t == task }, @set_size - 1, @time_block - task[:estimated_duration] - 10).best_of_size }
              .compact
              .select { |task_group| task_group.size == @set_size }
      end
    end

    def pick_one
      one = @tasks.select { |task| task[:estimated_duration] <= @time_block }
            .sort_by{ |task| task[:created_at] }
            .max_by { |task| task[:estimated_duration] }
      one ? one : []
    end
  end

  def self.pick_next(tasks, time_block)
    one = TaskSet.new(tasks, 1, time_block).best_of_size
    two = TaskSet.new(tasks, 2, time_block).best_of_size


    sets = []
    unless one.empty?
      sets << [one]
    end
    unless two.empty?
      sets << two
    end
    if sets.empty?
      sets
    else
      sets.max_by { |set| set.sum { |task| task[:estimated_duration] } }
          .sort_by { |task| task[:estimated_duration] }
          .reverse
    end
  end

  private
  # def self.pick_partner(tasks, task, time_block)
  #   pick_one(tasks.reject { |t| t == task }, time_block - task[:estimated_duration] - 10)
  # end
  #
  # def self.pick_two(tasks, time_block)
  #   tasks.map { |task| TaskSet.new(tasks - task, ) }.
  #         select(&:partner_task).
  #         max_by { |pair| pair.task[:estimated_duration] + pair.partner_task[:estimated_duration]}
  # end
end
