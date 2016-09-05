class PumaBacklogDetector
  class Railtie < Rails::Railtie
    config.puma_backlog_detector = ActiveSupport::OrderedOptions.new
    config.puma_backlog_detector.max_backlog = 16
    config.puma_backlog_detector.check_interval = 0.01
    config.puma_backlog_detector.flag_path = nil

    initializer "puma_backlog_detector.run" do
      conf = config.puma_backlog_detector
      if conf.flag_path
        @puma_backlog_detector = PumaBacklogDetector.new conf.flag_path, conf.max_backlog
        @puma_backlog_detector.check_in_background conf.check_interval
      end
    end
  end
end
