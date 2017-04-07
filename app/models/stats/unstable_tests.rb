module Stats
  class UnstableTests

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
            .where(passed: false).where(skipped: false)
            .joins(:testcase).group('testcases.name, testcases.file_name')
            .select('testcase_runs.*', 'count(*) as failed_count').order('count(*) desc')
            .limit(@test_count).map{|data| UnstableTest.new(data, data.failed_count)}
      end
    end

  end
end
