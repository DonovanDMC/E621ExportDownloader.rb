# frozen_string_literal: true
# typed: strict

require("csv")

module E621ExportDownloader
  class Export
    extend(T::Sig)
    extend(T::Generic)

    Model = type_member

    sig { returns(Date) }
    attr_accessor(:date)

    sig { returns(ExportHelper[Model]) }
    attr_accessor(:helper)

    sig { returns(T.nilable(T::Boolean)) }
    # If nil, no check has been performed yet
    attr_accessor(:downloaded)

    sig { params(date: T.any(Date, DateTime), helper: ExportHelper[Model]).void }
    def initialize(date:, helper:)
      @date = T.let(date.is_a?(DateTime) ? date.to_date : date, Date)
      @helper = helper
      @downloaded = T.let(nil, T.nilable(T::Boolean))
    end

    sig { returns(T::Boolean) }
    def delete
      return false unless check_downloaded
      FileUtils.rm(file_path)
      @downloaded = false
      true
    end

    sig { returns(String) }
    def download
      raise(ResolveError, "Export #{helper.type} for #{helper.format_date(date)} does not exist") unless exists?
      if check_downloaded
        helper.client.debug("using cached export for #{helper.type.serialize}", header: %W[export #{helper.format_date(date)}])
        return file_path
      end

      helper.client.debug("downloading export for #{helper.type.serialize}", header: %W[export #{helper.format_date(date)}])

      FileUtils.mkdir_p(Constants::TEMP_DIR)
      File.open(file_path, "wb") do |file|
        inflater = Zlib::Inflate.new(Zlib::MAX_WBITS + 16)

        res = helper.client.connection.get("#{file_name}.gz") do |req|
          req.options.on_data = proc do |chunk, _total|
            decompressed = inflater.inflate(chunk)
            file.write(decompressed) if decompressed && !decompressed.empty?
          end
        end

        file.write(inflater.finish)
        inflater.close
        file.close

        unless res.success?
          raise(ResolveError, "Failed to download export #{helper.type.serialize} for #{helper.format_date(date)}: #{res.status} #{res.reason_phrase}")
        end
      rescue # rubocop:disable Style/RescueStandardError
        FileUtils.rm_f(file_path)
        raise
      end

      @downloaded = true
      file_path
    end

    sig { returns(T::Boolean) }
    def exists?
      helper.client.connection.head("#{file_name}.gz").success?
    end

    sig { params(block: T.proc.params(arg0: Model, arg1: Integer).void).void }
    def read(&block)
      download unless check_downloaded
      helper.client.debug("reading export for #{helper.type.serialize}", header: %W[export #{helper.format_date(date)}])
      total = line_count
      CSV.foreach(file_path, headers: true) do |row|
        args = [helper.parser.call(T.cast(row, CSV::Row).to_hash), total]
        args = args.slice(0, block.arity) if block.arity != -1
        block.call(*T.unsafe(args))
      end
    end

    sig { returns(T::Array[Model]) }
    def read_all
      download unless check_downloaded
      helper.client.debug("reading all records for #{helper.type.serialize}", header: %W[export #{helper.format_date(date)}])
      results = []
      read do |record|
        results << record
      end
      results
    end

    private

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
    end

    sig { returns(String) }
    def file_path
      File.join(Constants::TEMP_DIR, file_name)
    end

    sig { returns(String) }
    def file_name
      "#{helper.type.serialize}-#{helper.format_date(date)}.csv"
    end
  end
end
