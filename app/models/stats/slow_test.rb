module Stats
  class SlowTest

    attr_reader :testcase_run
    attr_reader :time

    def initialize(testcase_run, time)
      @testcase_run = testcase_run
      @time = time
    end

  end
end
