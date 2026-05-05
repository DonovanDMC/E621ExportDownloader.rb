# frozen_string_literal: true
# typed: strong

module E621ExportDownloader
  module Models
    class Pool
      extend(T::Sig)

      sig { returns(T::Hash[String, String]) }
      attr_reader(:record)

      sig { returns(String) }
      attr_reader(:category)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(Integer) }
      attr_reader(:creator_id)

      sig { returns(String) }
      attr_reader(:description)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(T::Boolean) }
      attr_reader(:is_active)

      sig { returns(String) }
      attr_reader(:name)

      sig { returns(T::Array[Integer]) }
      attr_reader(:post_ids)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:updated_at)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @category = T.let(T.must(record["category"]), String)
        @created_at = T.let(DateTime.parse(record["created_at"]), DateTime)
        @creator_id = T.let(record["creator_id"].to_i, Integer)
        @description = T.let(T.must(record["description"]), String)
        @id = T.let(record["id"].to_i, Integer)
        @is_active = T.let(record["is_active"] == "t", T::Boolean)
        @name = T.let(T.must(record["name"]), String)
        @post_ids = T.let(T.must(T.must(record["post_ids"])[1..-2]).split(",").map(&:to_i), T::Array[Integer])
        @updated_at = T.let(T.must(record["updated_at"]).empty? ? nil : DateTime.parse(record["updated_at"]), T.nilable(DateTime))
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          category:    @category,
          created_at:  @created_at,
          creator_id:  @creator_id,
          description: @description,
          id:          @id,
          is_active:   @is_active,
          name:        @name,
          post_ids:    @post_ids,
          updated_at:  @updated_at,
        }.to_json
      end
    end
  end
end
