class Scheduler
  def self.pick_next(tasks, time_block)
    # Collect best matching sets of size 1 up to the full task list
    sets = []
    (1..tasks.size).each do |task_set_size|
      new_set = TaskSet.new(tasks, task_set_size, time_block).best_of_size
      break unless new_set
      sets << new_set
    end

    # Return the set that does the most work for the given block
    sets.empty? ? sets : sets.max_by { |set| set.sum { |task| task[:estimated_duration] } }
                             .sort_by { |task| [-task[:estimated_duration], task[:created_at]] }
  end
end
