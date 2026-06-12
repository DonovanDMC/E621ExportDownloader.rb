# frozen_string_literal: true

module E621ExportDownloader
  class Railtie < Rails::Railtie
    rake_tasks do
      load(File.expand_path("../tasks/e621_export_downloader.rake", __dir__))
    end

    initializer("e621_export_downloader.register_active_job_serializer") do
      ActiveSupport.on_load(:active_job) do
        require("e621_export_downloader/serializers/active_job")
        ActiveJob::Serializers.add_serializers(::E621ExportDownloader::Serializers::ActiveJob)
      end
    end
  end
end
