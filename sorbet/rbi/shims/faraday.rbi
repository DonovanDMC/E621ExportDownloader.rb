# typed: true

module Faraday
  class Request
    sig { returns(Symbol) }
    def http_method; end
    sig { returns(T.any(URI, String)) }
    def path; end
    sig { returns(Hash) }
    def params; end
    sig { returns(Faraday::Utils::Headers) }
    def headers; end
    sig { returns(String) }
    def body; end
    sig { returns(RequestOptions) }
    def options; end
  end

  class RequestOptions
    sig { params(value: T.proc.params(arg0: String, arg1: Integer).void).void }
    def on_data=(value); end
  end

  class Response
    sig { returns(Integer) }
    def status; end
    sig { returns(String) }
    def reason_phrase; end
  end

  module Connection
    sig { params(url: T.nilable(T.any(String, URI)), params: T.nilable(Hash), headers: T.nilable(Hash), block: T.nilable(T.proc.params(arg0: Faraday::Request).void)).returns(Faraday::Response) }
    def get(url = nil, params = nil, headers = nil, &block); end
    sig { params(url: T.nilable(T.any(String, URI)), params: T.nilable(Hash), headers: T.nilable(Hash), block: T.nilable(T.proc.params(arg0: Faraday::Request).void)).returns(Faraday::Response) }
    def head(url = nil, params = nil, headers = nil, &block); end
  end

  module Utils
    class Headers < ::Hash
    end
  end
end
