require 'spec_helper'
require 'tempfile'
require 'puma'

describe PumaBacklogDetector do
  describe "#initialize" do
    it "removes the flag file" do
      FileUtils.touch flag_path
      expect_rm
      expect(detector).to be
    end
  end

  describe "#check" do
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
    PumaBacklogDetector.new flag_path, max_backlog
  end

  let(:flag_path) do
    f = Tempfile.new('puma_backlog_detector')
    path = f.path
    f.unlink
    path
  end

  let(:max_backlog) { 7 }
  before { allow(Puma::Server).to receive(:current).and_return server }
  let(:server) { double Puma::Server }

  def expect_rm
    expect(FileUtils).to receive(:rm_f).with(flag_path)
  end

  def expect_touch
    expect(FileUtils).to receive(:touch).with(flag_path)
  end
end
