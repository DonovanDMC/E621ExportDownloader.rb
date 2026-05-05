# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class Client
    class Options
      class Builder
        class Parsers
          extend(T::Sig)

          sig { returns(Parser) }
          attr_accessor(:pools)

          sig { returns(Parser) }
          attr_accessor(:posts)

          sig { returns(Parser) }
          attr_accessor(:tag_aliases)

          sig { returns(Parser) }
          attr_accessor(:tag_implications)

          sig { returns(Parser) }
          attr_accessor(:tags)

          sig { returns(Parser) }
          attr_accessor(:wiki_pages)

          sig { params(defaults: Options::Parsers).void }
          def initialize(defaults = Options::Parsers.defaults)
            @pools = T.let(T.must(defaults.pools), Parser)
            @posts = T.let(T.must(defaults.posts), Parser)
            @tag_aliases = T.let(T.must(defaults.tag_aliases), Parser)
            @tag_implications = T.let(T.must(defaults.tag_implications), Parser)
            @tags = T.let(T.must(defaults.tags), Parser)
            @wiki_pages = T.let(T.must(defaults.wiki_pages), Parser)
          end
        end
      end
    end
  end
end
