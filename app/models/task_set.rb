class TaskSet
  attr_reader :tasks, :oldest_tasks, :set_size, :time_block

  def initialize(tasks, set_size, time_block)
    @tasks        = tasks
    @oldest_tasks = tasks.sort_by { |task| task[:created_at] }
                         .uniq { |task| task[:estimated_duration] }
    @set_size     = set_size
    @time_block   = time_block
  end

  def find_partner_task_subset(task)
    [TaskSet.new(tasks.reject{ |t| t == task },
                 set_size - 1,
                 time_block - task[:estimated_duration] - 10).best_of_size].compact
  end

  def best_of_size
    if set_size == 1
      pick_one
    else
      oldest_tasks.map { |task| [task, find_partner_task_subset(task)].flatten }
                  .select { |task_group| task_group.size == set_size }
                  .max_by { |task_group| task_group.sum { |task| task[:estimated_duration] } }
    end
  end

  def pick_one
    [oldest_tasks.select { |task| task[:estimated_duration] <= time_block }
                 .max_by { |task| task[:estimated_duration] }].compact
  end
end
