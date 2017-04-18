require 'junit_test_case'

class JUnitSuite
  attr_accessor :time, :skipped, :failures, :errors, :name, :assertions, :test_count
  attr_accessor :test_cases

  def initialize(xml)
    @time       = xml.attribute("time").try(:value)
    @skipped    = xml.attribute("skipped").try(:value).to_i
    @failures   = xml.attribute("failures").try(:value).to_i
    @errors     = xml.attribute("errors").try(:value).to_i
    @name       = xml.attribute("name").try(:value)
    @assertions = xml.attribute("assertions").try(:value).to_i
    @test_count = xml.attribute("tests").try(:value).to_i

    parse_test_cases(xml.xpath("testcase"))
  end

  def parse_test_cases(test_case_array)
    flattened_array = [test_case_array].flatten
    @test_cases = []

    flattened_array.each do |test_case_xml|
      test_case = JUnitTestCase.new(test_case_xml)

      test_cases << test_case
    end
  end

end
