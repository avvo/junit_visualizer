module Stats
  class SlowestTests

    DEFAULT_TEST_COUNT = 10
    DEFAULT_BUILD_COUNT = 100

    attr_reader :build_count
    attr_reader :test_count

    def initialize(project, build_count = DEFAULT_BUILD_COUNT, test_count = DEFAULT_TEST_COUNT)
      @project = project
      @build_count = build_count.to_i
      @test_count = test_count.to_i
    end

    def tests
      @tests ||= begin
        recent_build_ids = Build.where(project: @project).order(number: :desc).pluck(:id).first(@build_count)
        return [] unless recent_build_ids.present?

        TestcaseRun.where(build_id: recent_build_ids)
            .joins(:testcase).group('testcases.name, testcases.file_name')
            .select('testcase_runs.*', 'avg(testcase_runs.time) as average_time').order('avg(testcase_runs.time) desc')
            .limit(@test_count).map{|data| SlowTest.new(data, data.average_time)}
      end
    end

  end
end
