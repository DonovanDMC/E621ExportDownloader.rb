# frozen_string_literal: true
# typed: strict

require("tmpdir")
require("sorbet-runtime")
require_relative("version")

module E621ExportDownloader
  module Constants
    extend(T::Sig)

    API_URL = "https://e621.net/db_exports.json"
    BASE_URL = "https://e621.net/db_export/"
    EXPORT_NAMES = %w[artists bulk_update_requests pools posts post_replacements post_versions tag_aliases tag_implications tags wiki_pages].freeze
    TEMP_DIR = T.let(File.join(Dir.tmpdir, "e621-export-downloader"), String)
    USER_AGENT = T.let("E621ExportDownloader.rb/#{VERSION} (#{WEBSITE})", String)
  end
end
