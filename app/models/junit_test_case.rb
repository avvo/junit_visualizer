

class JUnitTestCase
  attr_accessor :time, :file, :name, :assertions, :failure, :error, :skipped
  attr_accessor :full_message

  attr_reader :message

  def initialize(xml)
    @time       = xml.attribute("time").try(:value)
    @file       = xml.attribute("file").try(:value)
    @name       = xml.attribute("name").try(:value)
    @assertions = xml.attribute("assertions").try(:value)

    @failure = process_failures(xml, "failure")
    @skipped = process_failures(xml, "skipped")
    @error   = process_failures(xml, "error")
  end

  def process_failures(xml, type)
    if !xml.xpath(type).empty?
      message = []
      message << "#{file}##{name}"
      message << xml.xpath(type).attribute("type").try(:value)
      message << xml.xpath(type).attribute("message").try(:value)
      message << xml.xpath(type).text

      @message = message.join("\n")
    end
  end

  def status
    return "skipped" if skipped?
    return "failure" if failure?
    return "error"   if error?
    return "passed"  if passed?
  end

  def skipped?
    skipped.present?
  end

  def failure?
    failure.present?
  end

  def error?
    error.present?
  end

  def passed?
    !skipped? && !failure? && !error?
  end

end
