class SuitePresenter
  FALSE = 0
  TRUE = 1

  def initialize(suite)
    @suite = suite
  end

  def name
    @suite.name.split("=")[1].split(",")[0]
  end

  def duration_in_seconds(build)
    testcase_runs_durations.fetch(build.id, 0)
  end

  def status(build)
    failure_count = testcase_runs_status_counts.fetch([build.id, FALSE, FALSE], 0)

    if failure_count > 0
      return STATUS_FAILURE
    else
      return STATUS_SUCCESS
    end
  end

  def stats
    builds = @suite.builds

    failure_count = 0
    success_count = 0

    builds.each do |build|
      if status(build) == STATUS_SUCCESS
        success_count += 1
      else
        failure_count += 1
      end
    end

    percent = ((success_count.to_f / (failure_count + success_count.to_f)) * 100).round(1)
    count = "#{success_count}/#{failure_count + success_count}"
    "#{percent}% (#{count})"
  end

  private

  def testcase_runs_durations
    @testcase_runs_durations ||= Testcase.where(suite: @suite).joins(:testcase_runs).group(:build_id).sum(:time)
  end

  def testcase_runs_status_counts
    @testcase_runs_status_counts ||= Testcase.where(suite: @suite).joins(:testcase_runs).group(:build_id, :passed, :skipped).count
  end


end
