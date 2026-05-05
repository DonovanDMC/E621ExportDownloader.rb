# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class Client
    class Options < T::Struct
      Parser = T.type_alias { T.proc.params(arg0: T::Hash[String, String]).returns(T.untyped) }

      class Parsers < T::Struct
        extend(T::Sig)

        const(:pools, T.nilable(Parser), default: nil)
        const(:posts, T.nilable(Parser), default: nil)
        const(:tag_aliases, T.nilable(Parser), default: nil)
        const(:tag_implications, T.nilable(Parser), default: nil)
        const(:tags, T.nilable(Parser), default: nil)
        const(:wiki_pages, T.nilable(Parser), default: nil)

        sig { returns(Parsers) }
        def self.defaults
          Parsers.new(
            pools:            ->(record) { Models::Pool.new(record) },
            posts:            ->(record) { Models::Post.new(record) },
            tag_aliases:      ->(record) { Models::TagAlias.new(record) },
            tag_implications: ->(record) { Models::TagImplication.new(record) },
            tags:             ->(record) { Models::Tag.new(record) },
            wiki_pages:       ->(record) { Models::WikiPage.new(record) },
          )
        end
      end

      const(:cache, T::Boolean, default: true)
      const(:rewind_on_not_found, T.any(T::Boolean, Integer), default: false)
      const(:parsers, Parsers, default: Parsers.defaults)
    end
  end
end
