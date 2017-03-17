class SuitePresenter
  def initialize(suite)
    @suite = suite
  end

  def name
    @suite.name.split("=")[1].split(",")[0]
  end

end
