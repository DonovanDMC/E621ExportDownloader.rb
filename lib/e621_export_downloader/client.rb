# frozen_string_literal: true
# typed: strict

require("faraday")

module E621ExportDownloader
  class Client
    extend(T::Sig)

    Logger = ::Logger.new($stdout)

    sig { returns(Options) }
    attr_reader(:options)

    sig { params(options: T.nilable(Options)).void }
    def initialize(options = nil)
      @options = T.let(options || Options.new, Options)
    end

    sig { params(block: T.proc.params(arg0: Options::Builder).void).void }
    def config(&block)
      block.call(Options::Builder.new(@options))
    end

    sig { returns(Faraday::Connection) }
    def connection
      Faraday.new(url: Constants::BASE_URL, headers: { "User-Agent" => Constants::USER_AGENT })
    end

    sig { params(msg: String, header: T::Array[String]).void }
    def debug(msg, header: [])
      Logger.debug("[e621_export_downloader#{":#{header.join(':')}" unless header.empty?}] #{msg}")
    end

    sig { params(type: T.any(Types, String)).returns(ExportHelper[T.untyped]) }
    def get(type)
      if type.is_a?(String)
        case type
        when "pools"
          type = Types::Pools
        when "posts"
          type = Types::Posts
        when "tag_aliases"
          type = Types::TagAliases
        when "tag_implications"
          type = Types::TagImplications
        when "tags"
          type = Types::Tags
        when "wiki_pages"
          type = Types::WikiPages
        else
          raise(ArgumentError, "invalid type: #{type}")
        end
      end

      T.assert_type!(type, Types)
      ExportHelper.new(client: self, type: type, parser: options.parsers.public_send(type.serialize))
    end

    sig { returns(ExportHelper[Models::Pool]) }
    def pools
      get(Types::Pools)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::Pool]) }
    def get_pools(date = Date.today)
      pools.get(date)
    end

    sig { returns(ExportHelper[Models::Post]) }
    def posts
      get(Types::Posts)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::Post]) }
    def get_posts(date = Date.today)
      posts.get(date)
    end

    sig { returns(ExportHelper[Models::TagAlias]) }
    def tag_aliases
      get(Types::TagAliases)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::TagAlias]) }
    def get_tag_aliases(date = Date.today)
      tag_aliases.get(date)
    end

    sig { returns(ExportHelper[Models::TagImplication]) }
    def tag_implications
      get(Types::TagImplications)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::TagImplication]) }
    def get_tag_implications(date = Date.today)
      tag_implications.get(date)
    end

    sig { returns(ExportHelper[Models::Tag]) }
    def tags
      get(Types::Tags)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::Tag]) }
    def get_tags(date = Date.today)
      tags.get(date)
    end

    sig { returns(ExportHelper[Models::WikiPage]) }
    def wiki_pages
      get(Types::WikiPages)
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Models::WikiPage]) }
    def get_wiki_pages(date = Date.today)
      wiki_pages.get(date)
    end
  end
end
