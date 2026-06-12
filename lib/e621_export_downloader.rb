# frozen_string_literal: true

require("zeitwerk")
require("sorbet-runtime")

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect({ "api_export_data" => "APIExportData" })
loader.ignore("#{__dir__}/e621_export_downloader/version.rb")
loader.ignore("#{__dir__}/e621_export_downloader/railtie.rb")
loader.ignore("#{__dir__}/e621_export_downloader/serializers/active_job.rb")
loader.ignore("#{__dir__}/e621_export_downloader/models.rb")
loader.ignore("#{__dir__}/e621")
loader.ignore("#{__dir__}/generators")
loader.setup

require("e621_export_downloader/railtie") if defined?(Rails::Railtie)

module E621ExportDownloader
  class ResolveError < StandardError; end
end
