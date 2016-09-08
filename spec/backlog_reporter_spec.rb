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
require 'spec_helper'
require 'tempfile'
require 'puma'

describe BacklogReporter do
  shared_context "with_puma_server" do
    before {
      allow(detector).to receive(:puma_server).and_return server 
    }
  end

  describe "#initialize" do
    it "removes the flag file" do
      FileUtils.touch flag_path
      expect_rm
      expect(File.exists?(flag_path)).to be(true)
      expect(detector).to be
    end
  end

  describe "#check" do
    include_context "with_puma_server"

    context "when Puma is not running" do
      let(:server) { nil }
      it "does nothing" do
        expect(FileUtils).not_to receive(:touch)
        expect(FileUtils).not_to receive(:rm_f)
        detector.check
      end
    end

    it "creates the flag file if the backlog is over the threshold" do
      allow(server).to receive(:backlog).and_return 42
      expect_touch
      detector.check
    end

    it "removes the flag file if the backlog is below the threshold" do
      allow(server).to receive(:backlog).and_return 42
      detector.check
      allow(server).to receive(:backlog).and_return 3
      expect_rm
      detector.check
    end
  end

  describe "#check_periodically" do
    include_context "with_puma_server"

    it "periodically checks the backlog" do
      recv_times = 0
      allow(detector).to receive(:check) do
        recv_times += 1
      end
      thread = Thread.new { detector.check_periodically 0.01 }
      sleep 0.1
      expect(thread).to be_alive
      thread.exit
      expect(recv_times).to be > 9
    end
  end

  describe "#check_in_background" do
    include_context "with_puma_server"

    it "runs a background checking thread" do
      recv_times = 0
      allow(detector).to receive(:check) do
        recv_times += 1
      end
      detector.check_in_background
      sleep 0.1
      detector.stop
      expect(recv_times).to be > 9
    end
  end

  subject(:detector) do
    BacklogReporter.new flag_path, max_backlog
  end

  let(:flag_path) do
    f = Tempfile.new('backlog_reporter')
    path = f.path
    f.unlink
    path
  end

  let(:max_backlog) { 7 }
  let(:server) { double Puma::Server }

  def expect_rm
    expect(FileUtils).to receive(:rm_f).with(flag_path)
  end

  def expect_touch
    expect(FileUtils).to receive(:touch).with(flag_path)
  end
end
