# frozen_string_literal: true

module E621ExportDownloader
  class Types < T::Enum
    enums do
      Artists = new("artists")
      BulkUpdateRequests = new("bulk_update_requests")
      Pools = new("pools")
      Posts = new("posts")
      PostReplacements = new("post_replacements")
      PostVersions = new("post_versions")
      TagAliases = new("tag_aliases")
      TagImplications = new("tag_implications")
      Tags = new("tags")
      WikiPages = new("wiki_pages")
    end
  end
end
