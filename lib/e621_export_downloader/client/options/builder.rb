# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class Client
    class Options
      class Builder
        extend(T::Sig)

        sig { returns(T::Boolean) }
        attr_accessor(:cache)

        sig { params(parsers: Options::Parsers).returns(Options::Parsers) }
        attr_writer(:parsers)

        sig { params(defaults: Options).void }
        def initialize(defaults = Options.new)
          @cache = T.let(defaults.cache, T::Boolean)
          @parsers = T.let(defaults.parsers, Options::Parsers)
        end

        sig { params(block: T.nilable(T.proc.params(arg0: Builder::Parsers).void)).returns(Options::Parsers) }
        def parsers(&block)
          return @parsers if block.nil?
          parsers = Builder::Parsers.new(@parsers)
          block.call(parsers)

          @parsers = Options::Parsers.new(
            artists:              parsers.artists,
            bulk_update_requests: parsers.bulk_update_requests,
            pools:                parsers.pools,
            posts:                parsers.posts,
            post_replacements:    parsers.post_replacements,
            post_versions:        parsers.post_versions,
            tag_aliases:          parsers.tag_aliases,
            tag_implications:     parsers.tag_implications,
            tags:                 parsers.tags,
            wiki_pages:           parsers.wiki_pages,
          )
        end
      end
    end
  end
end
