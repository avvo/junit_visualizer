require 'junit_suite'

class JUnitParser
  def self.parse_junit(filename)
    doc = File.open(filename) { |f| Nokogiri::XML(f)}

    JUnitSuite.new(doc.xpath("testsuite"))
  end
end
