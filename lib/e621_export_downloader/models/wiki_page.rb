# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class WikiPage
      extend(T::Sig)

      sig { returns(String) }
      attr_reader(:body)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:creator_id)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(T::Boolean) }
      attr_reader(:is_locked)

      sig { returns(String) }
      attr_reader(:title)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:updated_at)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:uploader_id)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @body = T.let(T.must(record["body"]).gsub("\r\n", "\n"), String)
        @created_at = T.let(DateTime.parse(record["created_at"]), DateTime)
        @creator_id = T.let(T.must(record["creator_id"]).empty? ? nil : record["creator_id"].to_i, T.nilable(Integer))
        @id = T.let(record["id"].to_i, Integer)
        @is_locked = T.let(record["is_locked"] == "t", T::Boolean)
        @title = T.let(T.must(record["title"]), String)
        @updated_at = T.let(T.must(record["updated_at"]).empty? ? nil : DateTime.parse(record["updated_at"]), T.nilable(DateTime))
        @uploader_id = T.let(T.must(record["uploader_id"]).empty? ? nil : record["uploader_id"].to_i, T.nilable(Integer))
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          body:        @body,
          created_at:  @created_at,
          creator_id:  @creator_id,
          id:          @id,
          is_locked:   @is_locked,
          title:       @title,
          updated_at:  @updated_at,
          uploader_id: @uploader_id,
        }.to_json
      end
    end
  end
end
