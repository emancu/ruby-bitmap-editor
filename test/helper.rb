require "protest"
require_relative '../lib/bitmap'
require_relative '../lib/bitmap_editor'

class Protest::TestCase
  # Passes if the code block raises the specified exception with the matching
  # message. If no exception is specified, passes if any exception is raised,
  # with the same message, otherwise it fails.
  def assert_error_message(exception_class=Exception, message_pattern)
    begin
      yield
    rescue exception_class => e
    ensure
      assert e, "Expected #{exception_class.name} to be raised"
      assert e.message.match(message_pattern), "Error message '#{e.message}' didn't match"
    end
  end


  # Ensure a condition is not met. This will raise AssertionFailed if the
  # condition is met. You can override the default failure message
  # by passing it as an argument.
  def refute(condition, message="Expected condition to be unsatisfied")
    @report.on_assertion
    raise AssertionFailed, message if condition
  end
end
