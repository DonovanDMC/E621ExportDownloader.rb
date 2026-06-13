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

    sig { params(value: T.untyped).void }
    def self.primary_key=(value); end

    sig { params(kwargs: T.untyped).returns(T.untyped) }
    def self.find_by(**kwargs); end

    sig { params(kwargs: T.untyped).returns(T.untyped) }
    def self.where(**kwargs); end
  end
end
