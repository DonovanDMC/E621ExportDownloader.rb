# frozen_string_literal: true

module E621ExportDownloader
  class Types < T::Enum
    enums do
      Pools = new("pools")
      Posts = new("posts")
      TagAliases = new("tag_aliases")
      TagImplications = new("tag_implications")
      Tags = new("tags")
      WikiPages = new("wiki_pages")
    end
  end
end
