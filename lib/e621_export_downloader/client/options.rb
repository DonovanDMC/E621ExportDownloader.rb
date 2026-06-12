# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class Client
    class Options < T::Struct
      Parser = T.type_alias { T.proc.params(arg0: T::Hash[String, String]).returns(T.untyped) }

      class Parsers < T::Struct
        extend(T::Sig)

        const(:artists, T.nilable(Parser), default: nil)
        const(:bulk_update_requests, T.nilable(Parser), default: nil)
        const(:pools, T.nilable(Parser), default: nil)
        const(:posts, T.nilable(Parser), default: nil)
        const(:post_replacements, T.nilable(Parser), default: nil)
        const(:post_versions, T.nilable(Parser), default: nil)
        const(:tag_aliases, T.nilable(Parser), default: nil)
        const(:tag_implications, T.nilable(Parser), default: nil)
        const(:tags, T.nilable(Parser), default: nil)
        const(:wiki_pages, T.nilable(Parser), default: nil)

        sig { returns(Parsers) }
        def self.defaults
          Parsers.new(
            artists:              ->(record) { E621ExportDownloader::Models::Artist.new(record) },
            bulk_update_requests: ->(record) { E621ExportDownloader::Models::BulkUpdateRequest.new(record) },
            pools:                ->(record) { E621ExportDownloader::Models::Pool.new(record) },
            posts:                ->(record) { E621ExportDownloader::Models::Post.new(record) },
            post_replacements:    ->(record) { E621ExportDownloader::Models::PostReplacement.new(record) },
            post_versions:        ->(record) { E621ExportDownloader::Models::PostVersion.new(record) },
            tag_aliases:          ->(record) { E621ExportDownloader::Models::TagAlias.new(record) },
            tag_implications:     ->(record) { E621ExportDownloader::Models::TagImplication.new(record) },
            tags:                 ->(record) { E621ExportDownloader::Models::Tag.new(record) },
            wiki_pages:           ->(record) { E621ExportDownloader::Models::WikiPage.new(record) },
          )
        end
      end

      const(:cache, T::Boolean, default: false)
      const(:parsers, Parsers, default: Parsers.defaults)
    end
  end
end
