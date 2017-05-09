require 'junit_suite'

class JUnitParser
  def self.parse_junit(raw_data)
    doc = Nokogiri::XML(raw_data)

    suite_data = doc.xpath("testsuite")

    if suite_data.present?
      JUnitSuite.new(suite_data)
    end
  end
end
