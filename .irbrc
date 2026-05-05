# frozen_string_literal: true
# typed: true

require_relative("lib/e621_export_downloader")
require("sorbet-runtime")

extend(T::Sig) # rubocop:disable Style/MixinUsage

E621ExportDownloader::Client::Logger.level = Logger::DEBUG

sig { returns(E621ExportDownloader::Client) }
def client
  E621ExportDownloader::Client.new
end
