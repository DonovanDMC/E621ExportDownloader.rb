# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class Artist
      extend(T::Sig)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(Integer) }
      attr_reader(:creator_id)

      sig { returns(T.nilable(String)) }
      attr_reader(:group_name)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(T::Boolean) }
      attr_reader(:is_active)

      sig { returns(T::Boolean) }
      attr_reader(:is_locked)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:linked_user_id)

      sig { returns(String) }
      attr_reader(:name)

      sig { returns(T::Array[String]) }
      attr_reader(:other_names)

      sig { returns(DateTime) }
      attr_reader(:updated_at)

      sig { returns(T::Array[String]) }
      attr_reader(:urls)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @created_at     = T.let(DateTime.parse(record["created_at"]), DateTime)
        @creator_id     = T.let(record["creator_id"].to_i, Integer)
        @group_name     = T.let(T.must(record["group_name"]).empty? ? nil : record["group_name"], T.nilable(String))
        @id             = T.let(record["id"].to_i, Integer)
        @is_active      = T.let(record["is_active"] == "t", T::Boolean)
        @is_locked      = T.let(record["is_locked"] == "t", T::Boolean)
        @linked_user_id = T.let(T.must(record["linked_user_id"]).empty? ? nil : record["linked_user_id"].to_i, T.nilable(Integer))
        @name           = T.let(T.must(record["name"]), String)
        inner           = T.must(T.must(record["other_names"])[1..-2])
        @other_names    = T.let(inner.empty? ? [] : inner.split(","), T::Array[String])
        @updated_at     = T.let(DateTime.parse(record["updated_at"]), DateTime)
        @urls           = T.let(T.must(record["urls"]).split("\n"), T::Array[String])
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          created_at:     @created_at,
          creator_id:     @creator_id,
          group_name:     @group_name,
          id:             @id,
          is_active:      @is_active,
          is_locked:      @is_locked,
          linked_user_id: @linked_user_id,
          name:           @name,
          other_names:    @other_names,
          updated_at:     @updated_at,
          urls:           @urls,
        }.to_json
      end
    end
  end
end
