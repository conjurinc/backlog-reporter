require 'spec_helper'
require 'tempfile'

describe PumaBacklogDetector do
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

  describe "#initialize" do
    it "removes the flag file" do
      FileUtils.touch flag_path
      expect(FileUtils).to receive(:rm_f).with flag_path
      expect(detector).to be
    end
  end

  describe "#check" do
    it "does nothing if there is no Puma server started"
    it "creates the flag file if the backlog is over the threshold"
    it "removes the flag file if the backlog is below the threshold"
  end

  describe "#check_periodically" do
    it "periodically checks the backlog"
  end

  describe "#check_in_background" do
    it "runs a background checking thread"
  end
end
