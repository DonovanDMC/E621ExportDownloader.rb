# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class Tag
      extend(T::Sig)

      sig { returns(String) }
      attr_reader(:category)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(String) }
      attr_reader(:name)

      sig { returns(Integer) }
      attr_reader(:post_count)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @category = T.let(T.must(record["category"]), String)
        @id = T.let(record["id"].to_i, Integer)
        @name = T.let(T.must(record["name"]), String)
        @post_count = T.let(record["post_count"].to_i, Integer)
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          category:   @category,
          id:         @id,
          name:       @name,
          post_count: @post_count,
        }.to_json
      end
    end
  end
end
