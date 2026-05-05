# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class Client
    class Options
      class Builder
        extend(T::Sig)

        sig { returns(T::Boolean) }
        attr_accessor(:cache)

        sig { returns(T.any(T::Boolean, Integer)) }
        attr_accessor(:rewind_on_not_found)

        sig { params(parsers: Options::Parsers).returns(Options::Parsers) }
        attr_writer(:parsers)

        sig { params(defaults: Options).void }
        def initialize(defaults = Options.new)
          @cache = T.let(defaults.cache, T::Boolean)
          @rewind_on_not_found = T.let(defaults.rewind_on_not_found, T.any(T::Boolean, Integer))
          @parsers = T.let(defaults.parsers, Options::Parsers)
        end

        sig { params(block: T.nilable(T.proc.params(arg0: Builder::Parsers).void)).returns(Options::Parsers) }
        def parsers(&block)
          return @parsers if block.nil?
          parsers = Builder::Parsers.new(@parsers)
          block.call(parsers)

          @parsers = Options::Parsers.new(
            pools:            parsers.pools,
            posts:            parsers.posts,
            tag_aliases:      parsers.tag_aliases,
            tag_implications: parsers.tag_implications,
            tags:             parsers.tags,
            wiki_pages:       parsers.wiki_pages,
          )
        end
      end
    end
  end
end
