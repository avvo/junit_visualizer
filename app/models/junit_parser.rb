require 'junit_suite'

class JUnitParser
  def self.parse_junit(filename)
    doc = File.open(filename) { |f| Nokogiri::XML(f)}

    suite_data = doc.xpath("testsuite")

    if suite_data.present?
      JUnitSuite.new(suite_data)
    end
  end
end
