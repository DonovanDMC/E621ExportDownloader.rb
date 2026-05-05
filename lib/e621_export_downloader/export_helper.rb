# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class ExportHelper
    extend(T::Sig)
    extend(T::Generic)

    Model = type_member

    sig { returns(Types) }
    attr_reader(:type)

    sig { returns(Client::Options::Parser) }
    attr_reader(:parser)

    sig { returns(Client) }
    attr_reader(:client)

    sig { params(type: Types, parser: Client::Options::Parser, client: Client).void }
    def initialize(type:, parser:, client:)
      @type = type
      @parser = parser
      @client = client
      @rewind_count = T.let(0, Integer)
    end

    sig { params(date: T.any(Date, DateTime)).returns(String) }
    def format_date(date)
      date.strftime("%Y-%m-%d")
    end

    sig { params(date: T.any(Date, DateTime)).returns(T::Boolean) }
    def delete(date)
      client.debug("deleting export for #{type.serialize}", header: %W[helper #{format_date(date)}])
      _get(date).delete
    end

    sig { params(date: T.any(Date, DateTime)).returns(String) }
    def download(date)
      client.debug("downloading export for #{type.serialize}", header: %W[helper #{format_date(date)}])
      _get(date).download
    end

    sig { params(date: T.any(Date, DateTime)).returns(T::Boolean) }
    def exists?(date)
      client.debug("checking export existence for #{type.serialize}", header: %W[helper #{format_date(date)}])
      _get(date).exists?
    end

    sig { params(date: T.any(Date, DateTime)).returns(Export[Model]) }
    def get(date)
      client.debug("creating export handle for #{type.serialize}", header: %W[helper #{format_date(date)}])
      Export.new(date: date, helper: self)
    end

    private

    sig { returns(Integer) }
    def max_rewind_count
      return 0 if client.options.rewind_on_not_found == false
      return 2 if client.options.rewind_on_not_found == true
      T.cast(client.options.rewind_on_not_found, Integer)
    end

    sig { params(date: T.any(Date, DateTime), original_date: T.any(Date, DateTime)).returns(Export[Model]) }
    def _get(date, original_date = date)
      export = get(date)
      if export.exists?
        client.debug("resolved export for #{type.serialize}", header: %w[helper])
        return export
      end

      if @rewind_count < max_rewind_count
        @rewind_count += 1
        client.debug("rewinding export lookup for #{type.serialize} from #{format_date(original_date)} (attempt #{@rewind_count}/#{max_rewind_count})", header: %w[helper])
        return _get(date.to_date + 1, original_date)
      end

      raise(ResolveError, "Export #{type.serialize} for #{format_date(original_date)} does not exist, and either rewinding is not allowed or the maximum rewind limit has been reached")
    end
  end
end
