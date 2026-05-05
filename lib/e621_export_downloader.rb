# frozen_string_literal: true

require("zeitwerk")
require("sorbet-runtime")

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/e621_export_downloader/version.rb")
loader.setup

module E621ExportDownloader
  class ResolveError < StandardError; end
end
