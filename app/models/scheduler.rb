class Scheduler
  def self.pick_next(tasks, time_block, buffer)
    # puts "deadline tasks:"
    deadline_tasks = tasks.select { |task| task[:deadline] }
    # puts "no deadline tasks:"
    no_deadline_tasks = tasks.reject { |task| task[:deadline] }

    if deadline_tasks.empty?
      best_fit_from_group tasks, time_block, buffer
    else
      deadline_task_groups = deadline_tasks.group_by { |task| task[:deadline] }
      return_tasks = []
      new_time_block = time_block
      deadline_task_groups.keys.sort.each do |deadline|
        earliest_deadline_tasks = deadline_task_groups[deadline]
        new_tasks = best_fit_from_group(earliest_deadline_tasks, new_time_block, buffer)
        return_tasks << new_tasks
        new_time_block -= new_tasks.sum { |task| task[:estimated_duration] } + new_tasks.size * buffer
        break unless new_time_block > 0
      end
      if new_time_block > 0
        return_tasks << best_fit_from_group(no_deadline_tasks, new_time_block, buffer)
      end
      return_tasks.flatten.compact
    end
  end

  def self.best_fit_from_group(tasks, time_block, buffer)
    # Collect best matching sets of size 1 up to the full task list
    sets = []
    (1..tasks.size).each do |task_set_size|
      new_set = TaskSet.new(tasks, task_set_size, time_block, buffer).best_of_size
      break unless new_set
      sets << new_set
    end

    # Return the set that does the most work for the given block
    sets.empty? ? sets : sets.max_by { |set| set.sum { |task| task[:estimated_duration] } }
                             .sort_by { |task| [-task[:estimated_duration], task[:created_at]] }
  end
end
