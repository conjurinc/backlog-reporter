require "puma_backlog_detector/version"

class PumaBacklogDetector
  def initialize flag_path, max_backlog
    @flag = FlagFile.new flag_path
    @max_backlog = max_backlog
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
