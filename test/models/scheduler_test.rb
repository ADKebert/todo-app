require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def assert_expected_tasks(expected_tasks, tasks, time_block)
    assert_equal(expected_tasks, Scheduler.pick_next(tasks, time_block))
  end

  # Testing selection of single tasks with no deadline
  test "select the longest task when only one fits" do
    longest = { estimated_duration: 21, created_at: "2016-09-22 10:20:20" }
    long    = { estimated_duration: 20, created_at: "2016-09-22 10:20:20" }
    short   = { estimated_duration: 19, created_at: "2016-09-22 10:20:20" }
    tasks = [longest, long, short]
    time_block_greater_than_all_durations = 25

    assert_expected_tasks [longest], tasks, time_block_greater_than_all_durations
  end

  test "select the longest task that will fit into the slot when only one fits" do
    longest = { estimated_duration: 29, created_at: "2016-09-22 10:20:20" }
    longer  = { estimated_duration: 22, created_at: "2016-09-22 10:20:20" }
    long    = { estimated_duration: 20, created_at: "2016-09-22 10:20:20" }
    short   = { estimated_duration: 19, created_at: "2016-09-22 10:20:20" }
    tasks = [longest, longer, long, short]
    time_block_greater_than_most_durations = 24

    assert_expected_tasks [longer], tasks, time_block_greater_than_most_durations
  end

  test "picks the oldest test to break a tie" do
    older  = { estimated_duration: 20, created_at: "2016-09-22 10:20:21" }
    oldest = { estimated_duration: 20, created_at: "2016-09-22 10:20:20" }
    newer  = { estimated_duration: 20, created_at: "2016-09-22 11:30:20" }
    newest = { estimated_duration: 20, created_at: "2016-10-22 10:20:20" }
    tasks  = [older, oldest, newer, newest]
    time_block_greater_than_all_durations = 27

    assert_expected_tasks [oldest], tasks, time_block_greater_than_all_durations
  end

  test "returns nil when no tasks match" do
    longest  = { estimated_duration: 49, created_at: "2016-09-22 10:20:20" }
    longer2  = { estimated_duration: 34, created_at: "2016-09-22 10:20:20" }
    longer   = { estimated_duration: 32, created_at: "2016-09-22 10:20:20" }
    too_long = { estimated_duration: 39, created_at: "2016-09-22 10:20:20" }
    tasks = [longest, longer2, longer, too_long]
    time_block_shorter_than_all_durations = 23

    assert_expected_tasks [], tasks, time_block_shorter_than_all_durations
  end

  # Testing selection of tasks with no deadline when 2 can fit into the time block
  test "selects a single task when more work is done than two tasks" do
    long   = { estimated_duration: 40, created_at: "2016-09-22 10:20:21" }
    short  = { estimated_duration: 10, created_at: "2016-09-22 10:20:20" }
    short2 = { estimated_duration: 10, created_at: "2016-09-23 11:30:20" }
    tasks = [long, short, short2]
    time_block_ideal_for_largest_single_task = 45

    assert_expected_tasks [long], tasks, time_block_ideal_for_largest_single_task
  end

  test "selects two tasks when more work is done than by the biggest single task" do
    long   = { estimated_duration: 40, created_at: "2016-09-22 10:20:21" }
    short  = { estimated_duration: 30, created_at: "2016-09-22 10:20:20" }
    short2 = { estimated_duration: 20, created_at: "2016-09-22 11:30:20" }
    tasks = [long, short, short2]
    time_block_ideal_for_two_short_tasks = 60

    assert_expected_tasks [short, short2], tasks, time_block_ideal_for_two_short_tasks
  end

  test "selects two tasks that best fill the time block when multiple pairs will fit" do
    long     = { estimated_duration: 54, created_at: "2016-09-22 10:20:21" }
    medium   = { estimated_duration: 30, created_at: "2016-09-22 10:20:20" }
    medium2  = { estimated_duration: 35, created_at: "2016-09-22 11:30:20" }
    short    = { estimated_duration: 20, created_at: "2016-10-22 11:30:20" }
    tasks = [long, medium, medium2, short]
    time_block_ideal_for_a_pair = 70

    # For clarity this test expects a 10 minute buffer between tasks so [medium, medium2] doesn't fit
    assert_expected_tasks [medium2, short], tasks, time_block_ideal_for_a_pair
  end

  test "breaks ties for pairs by picking older tasks first" do
    old_long  = { estimated_duration: 30, created_at: "2016-09-22 10:20:20" }
    new_long  = { estimated_duration: 30, created_at: "2016-09-23 2:20:20" }
    old_short = { estimated_duration: 20, created_at: "2016-08-22 10:20:20" }
    new_short = { estimated_duration: 20, created_at: "2016-10-22 10:20:20" }
    tasks = [old_long, new_long, old_short, new_short]
    time_block_to_grab_one_long_one_short = 60

    assert_expected_tasks [old_long, old_short], tasks, time_block_to_grab_one_long_one_short

    tasks = [new_long, old_long, new_short, old_short]
    assert_expected_tasks [old_long, old_short], tasks, time_block_to_grab_one_long_one_short
  end

  test "selects tasks with non unique durations when appropriate" do
    match1 = { estimated_duration: 30, created_at: "2016-09-22 10:30:20" }
    match2 = { estimated_duration: 30, created_at: "2016-09-22 10:20:20" }
    single = { estimated_duration: 50, created_at: "2016-09-22 10:40:20" }
    tasks = [match2, match1, single]
    time_block_ideal_for_match1_and_match2 = 70

    assert_expected_tasks [match1, match2], tasks, time_block_ideal_for_match1_and_match2
  end

  test "selects three tasks when all three fit the time block" do
    triplet1 = { estimated_duration: 10, created_at: "2016-09-22 10:30:20" }
    triplet2 = { estimated_duration: 20, created_at: "2016-09-22 10:40:20" }
    triplet3 = { estimated_duration: 30, created_at: "2016-09-22 10:50:20" }
    tasks = [triplet1, triplet2, triplet3]
    time_block_large_enough_for_all_three = 90

    assert_expected_tasks [triplet3, triplet2, triplet1], tasks, time_block_large_enough_for_all_three
  end

  test "selects best three tasks when multiple triplets fit the time block" do
    triplet1 = { estimated_duration: 13, created_at: "2016-09-22 10:30:20" }
    triplet2 = { estimated_duration: 14, created_at: "2016-09-22 10:40:20" }
    triplet3 = { estimated_duration: 15, created_at: "2016-09-22 10:50:20" }
    triplet4 = { estimated_duration: 16, created_at: "2016-09-22 10:20:20" }
    triplet5 = { estimated_duration: 17, created_at: "2016-09-22 10:10:20" }
    triplet6 = { estimated_duration: 18, created_at: "2016-09-22 10:15:20" }
    tasks = [triplet1, triplet2, triplet3, triplet4, triplet5, triplet6]
    time_block_large_enough_for_many_triplets = 70

    assert_expected_tasks [triplet6, triplet5, triplet3], tasks, time_block_large_enough_for_many_triplets

    time_block_large_enough_for_many_triplets = 71
    assert_expected_tasks [triplet6, triplet5, triplet4], tasks, time_block_large_enough_for_many_triplets
  end

  test "selects an arbitrary number of tasks based on the time block" do
    small1     = { estimated_duration: 10, created_at: "2016-09-22 10:30:20" }
    small2     = { estimated_duration: 13, created_at: "2016-09-22 10:30:23" }
    small3     = { estimated_duration: 12, created_at: "2016-09-22 10:30:25" }
    small4     = { estimated_duration: 11, created_at: "2016-09-22 10:30:27" }
    small5     = { estimated_duration: 15, created_at: "2016-09-22 10:30:29" }
    really_big = { estimated_duration: 70, created_at: "2016-09-22 10:30:20" }
    tasks = [small1, small2, small3, small4, small5, really_big]

    time_block_for_one_small_task = 20
    assert_expected_tasks [small5], tasks, time_block_for_one_small_task

    time_block_for_three_small_tasks = 65
    assert_expected_tasks [small5, small2, small3], tasks, time_block_for_three_small_tasks

    time_block_for_one_really_big_task = 70
    assert_expected_tasks [really_big], tasks, time_block_for_one_really_big_task

    time_block_for_one_big_and_one_small_task = 93
    assert_expected_tasks [really_big, small2], tasks, time_block_for_one_big_and_one_small_task

    only_small_tasks = [small1, small2, small3, small4, small5]
    time_block_for_all_five_small_tasks = 101
    assert_expected_tasks [small5, small2, small3, small4, small1], only_small_tasks, time_block_for_all_five_small_tasks
  end
end
