# frozen_string_literal: true
# typed: strict

require("csv")

module E621ExportDownloader
  class Export
    extend(T::Sig)
    extend(T::Generic)

    Model = type_member

    sig { returns(APIExportData) }
    attr_accessor(:data)

    sig { returns(Client) }
    attr_accessor(:client)

    sig { returns(Types) }
    attr_accessor(:type)

    sig { returns(T.nilable(T::Boolean)) }
    attr_accessor(:downloaded)

    sig { params(data: APIExportData, client: Client, type: Types, parser: Client::Options::Parser).void }
    def initialize(data:, client:, type:, parser:)
      @data = T.let(data, APIExportData)
      @client = T.let(client, Client)
      @type = T.let(type, Types)
      @parser = T.let(parser, Client::Options::Parser)
      @downloaded = T.let(nil, T.nilable(T::Boolean))
    end

    sig { returns(T::Boolean) }
    def delete
      return false unless check_downloaded
      client.debug("deleting cached export", header: ["export:#{type.serialize}"])
      FileUtils.rm(file_path)
      @downloaded = false
      true
    end

    sig { returns(String) }
    def download
      raise(ResolveError, "Export #{type.serialize} does not exist") unless exists?
      if check_downloaded
        client.debug("using cached export", header: ["export:#{type.serialize}"])
        return file_path
      end

      client.debug("downloading export", header: ["export:#{type.serialize}"])

      FileUtils.mkdir_p(Constants::TEMP_DIR)
      File.open(file_path, "wb") do |file|
        inflater = Zlib::Inflate.new(Zlib::MAX_WBITS + 16)

        res = client.connection.get(data.url) do |req|
          req.options.on_data = proc do |chunk, _total|
            decompressed = inflater.inflate(chunk)
            file.write(decompressed) if decompressed && !decompressed.empty?
          end
        end

        file.write(inflater.finish)
        inflater.close
        file.close

        unless res.success?
          raise(ResolveError, "Failed to download export #{type.serialize}: #{res.status} #{res.reason_phrase}")
        end
      rescue # rubocop:disable Style/RescueStandardError
        FileUtils.rm_f(file_path)
        raise
      end

      @downloaded = true
      client.debug("download complete: #{file_path}", header: ["export:#{type.serialize}"])
      file_path
    end

    sig { returns(T::Boolean) }
    def exists?
      result = client.connection.head(data.url).success?
      client.debug("checked export existence: #{result}", header: ["export:#{type.serialize}"])
      result
    end

    sig { params(block: T.proc.params(arg0: Model, arg1: Integer).void).void }
    def read(&block)
      download unless check_downloaded
      client.debug("reading export", header: ["export:#{type.serialize}"])
      total = line_count
      CSV.foreach(file_path, headers: true, converters: ->(f) { f.nil? ? "" : f }) do |row|
        args = [@parser.call(T.cast(row, CSV::Row).to_hash), total]
        args = args.slice(0, block.arity) if block.arity != -1
        block.call(*T.unsafe(args))
      end
      client.debug("finished reading export", header: ["export:#{type.serialize}"])
      delete unless client.options.cache
    end

    sig { returns(T::Array[Model]) }
    def read_all
      client.debug("reading all records", header: ["export:#{type.serialize}"])
      results = []
      read do |record|
        results << record
      end
      results
    end

    private

    sig { returns(String) }
    def format_date
      DateTime.parse(data.updated_at).strftime("%Y-%m-%d")
    end

    sig { returns(Integer) }
    def line_count
      total = 0
      CSV.foreach(file_path) { total += 1 }
      total
    end

    sig { returns(T::Boolean) }
    def check_downloaded
      return @downloaded unless @downloaded.nil?
      @downloaded = File.exist?(file_path)
      client.debug("checked downloaded state: #{@downloaded}", header: ["export:#{type.serialize}"])
      @downloaded
    end

    sig { returns(String) }
    def file_path
      File.join(Constants::TEMP_DIR, file_name)
    end

    sig { returns(String) }
    def file_name
      "#{type.serialize}-#{format_date}.csv"
    end
  end
end
