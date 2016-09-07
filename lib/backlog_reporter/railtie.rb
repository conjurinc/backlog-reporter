#
# Copyright (C) 2016 Conjur Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
class BacklogReporter
  class Railtie < Rails::Railtie
    config.backlog_reporter = ActiveSupport::OrderedOptions.new
    config.backlog_reporter.max_backlog = 16
    config.backlog_reporter.check_interval = 0.01
    config.backlog_reporter.flag_path = nil

    initializer "backlog_reporter.run" do
      conf = config.backlog_reporter
      if conf.flag_path
        @backlog_reporter = BacklogReporter.new conf.flag_path, conf.max_backlog
        @backlog_reporter.check_in_background conf.check_interval
      end
    end
  end
end