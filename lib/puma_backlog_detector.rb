require "puma_backlog_detector/version"

class PumaBacklogDetector
  def initialize flag_path, max_backlog
    @flag = FlagFile.new flag_path
    @max_backlog = max_backlog
  end

  def check
    if server = Puma::Server.current
      @flag.set server.backlog > @max_backlog
    end
  end

  def check_periodically interval_s = 0.01
    while true
      check
      sleep interval_s
    end
  end

  def check_in_background interval_s = 0.01
    @thread = Thread.new { check_periodically interval_s }
  end

  def stop
    if @thread
      @thread.exit
      @thread.join
      @thread = nil
    end
  end

  class FlagFile
    def initialize path
      @path = path
      @exists = File.exists? path
      set false
    end

    def set value
      if @exists != value
        FileUtils.send((value ? :touch : :rm_f), @path)
        @exists = value
      end
    end
  end
end
