$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'

Coveralls.wear!

module Kernel
  alias old_sleep sleep
  def sleep(seconds)
    old_sleep(seconds * 0.01)
  end
end
