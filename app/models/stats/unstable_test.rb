module Stats
  class UnstableTest

    attr_reader :testcase_run
    attr_reader :failed_count

    def initialize(testcase_run, failed_count)
      @testcase_run = testcase_run
      @failed_count = failed_count
    end

  end
end
