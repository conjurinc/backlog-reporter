require 'spec_helper'

describe PumaBacklogDetector do
  describe "#initialize" do
    it "removes the flag file"
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
