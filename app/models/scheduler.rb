class Scheduler
  def self.pick_next(tasks, time_block)
    # one = TaskSet.new(tasks, 1, time_block).best_of_size
    # two = TaskSet.new(tasks, 2, time_block).best_of_size
    # three = TaskSet.new(tasks, 3, time_block).best_of_size
    sets = []
    (1..tasks.size).each do |task_set_size|
      new_set = TaskSet.new(tasks, task_set_size, time_block).best_of_size
      break unless new_set
      sets << new_set
    end

    if sets.empty?
      sets
    else
      sets.max_by { |set| set.sum { |task| task[:estimated_duration] } }
          .sort_by { |task| [-task[:estimated_duration], task[:created_at]] }
    end
  end
end
