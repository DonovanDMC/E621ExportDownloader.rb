# typed: true

module ActiveRecord
  class Base
    sig { params(value: T.untyped).void }
    def self.table_name=(value); end

    sig { params(value: T.untyped).void }
    def self.record_timestamps=(value); end

    sig { params(attributes: T::Hash[Symbol, T.untyped], kwargs: T.untyped).returns(T.untyped) }
    def self.upsert(attributes, **kwargs); end

    sig { params(attributes: T::Array[T::Hash[Symbol, T.untyped]], kwargs: T.untyped).returns(T.untyped) }
    def self.upsert_all(attributes, **kwargs); end
  end
end
