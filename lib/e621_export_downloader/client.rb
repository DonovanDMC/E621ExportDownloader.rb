# frozen_string_literal: true
# typed: strict

require("faraday")
require("json")

module E621ExportDownloader
  class Client
    extend(T::Sig)

    Logger = ::Logger.new($stdout)

    sig { returns(Options) }
    attr_reader(:options)

    sig { params(options: T.nilable(Options)).void }
    def initialize(options = nil)
      @options = T.let(options || Options.new, Options)
      @export_cache = T.let(nil, T.nilable(T::Array[APIExportData]))
    end

    sig { params(block: T.proc.params(arg0: Options::Builder).void).void }
    def config(&block)
      block.call(Options::Builder.new(@options))
    end

    sig { returns(Faraday::Connection) }
    def connection
      Faraday.new(headers: { "User-Agent" => Constants::USER_AGENT })
    end

    sig { params(msg: String, header: T::Array[String]).void }
    def debug(msg, header: [])
      Logger.debug("[e621_export_downloader#{":#{header.join(':')}" unless header.empty?}] #{msg}")
    end

    sig { params(type: T.any(Types, String)).returns(Export[T.untyped]) }
    def get(type)
      type = string_to_type(type) if type.is_a?(String)
      T.assert_type!(type, Types)
      data = get_data.find { |d| d.name == type }
      raise(ResolveError, "Export data for \"#{type.serialize}\" not found") if data.nil?
      debug("creating export for #{type.serialize}")
      Export.new(data: data, client: self, type: type, parser: options.parsers.public_send(type.serialize))
    end

    sig { params(type: T.any(Types, String)).returns(ExportHelper[T.untyped]) }
    def get_deferred(type)
      type = string_to_type(type) if type.is_a?(String)
      T.assert_type!(type, Types)
      debug("creating deferred export for #{type.serialize}")
      ExportHelper.new(type: type, client: self)
    end

    sig { returns(T::Array[APIExportData]) }
    def get_data
      return @export_cache unless @export_cache.nil?
      debug("fetching export data from api")
      res = connection.get(Constants::API_URL)
      raise(ResolveError, "Failed to fetch exports: #{res.status} #{res.reason_phrase}") unless res.success?
      data = JSON.parse(T.unsafe(res).body)
      result = T.let(data.map do |d|
        APIExportData.new(
          file_name:  d["file_name"],
          file_size:  d["file_size"].to_i,
          name:       Types.deserialize(d["name"]),
          updated_at: d["updated_at"],
          url:        d["url"],
        )
      end, T::Array[APIExportData])
      @export_cache = result
    end

    private

    sig { params(type: String).returns(Types) }
    def string_to_type(type)
      case type
      when "artists"              then Types::Artists
      when "bulk_update_requests" then Types::BulkUpdateRequests
      when "pools"                then Types::Pools
      when "posts"                then Types::Posts
      when "post_replacements"    then Types::PostReplacements
      when "post_versions"        then Types::PostVersions
      when "tag_aliases"          then Types::TagAliases
      when "tag_implications"     then Types::TagImplications
      when "tags"                 then Types::Tags
      when "wiki_pages"           then Types::WikiPages
      else raise(ArgumentError, "invalid type: #{type}")
      end
    end
  end
end
