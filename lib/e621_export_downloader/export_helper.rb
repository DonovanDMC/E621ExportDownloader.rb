# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class ExportHelper
    extend(T::Sig)
    extend(T::Generic)

    Model = type_member

    sig { returns(Types) }
    attr_reader(:type)

    sig { returns(Client) }
    attr_reader(:client)

    sig { params(type: Types, client: Client).void }
    def initialize(type:, client:)
      @type = type
      @client = client
      @_get = T.let(nil, T.nilable(Export[Model]))
    end

    sig { returns(T::Boolean) }
    def delete
      _get.delete
    end

    sig { returns(String) }
    def download
      _get.download
    end

    sig { returns(T::Boolean) }
    def exists?
      _get.exists?
    end

    sig { returns(Export[Model]) }
    def get
      _get
    end

    sig { params(block: T.proc.params(arg0: Model, arg1: Integer).void).void }
    def read(&block)
      _get.read(&block)
    end

    sig { returns(T::Array[Model]) }
    def read_all
      _get.read_all
    end

    private

    sig { returns(Export[Model]) }
    def _get
      @_get ||= client.get(type)
    end
  end
end
