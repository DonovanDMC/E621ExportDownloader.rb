# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class PostReplacement
      extend(T::Sig)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:approver_id)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(Integer) }
      attr_reader(:creator_id)

      sig { returns(String) }
      attr_reader(:file_ext)

      sig { returns(String) }
      attr_reader(:file_name)

      sig { returns(Integer) }
      attr_reader(:file_size)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(Integer) }
      attr_reader(:image_height)

      sig { returns(Integer) }
      attr_reader(:image_width)

      sig { returns(String) }
      attr_reader(:md5)

      sig { returns(Integer) }
      attr_reader(:post_id)

      sig { returns(String) }
      attr_reader(:reason)

      sig { returns(T.nilable(String)) }
      attr_reader(:source)

      sig { returns(String) }
      attr_reader(:status)

      sig { returns(DateTime) }
      attr_reader(:updated_at)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record       = T.let(record, T::Hash[String, String])
        @approver_id  = T.let(T.must(record["approver_id"]).empty? ? nil : record["approver_id"].to_i, T.nilable(Integer))
        @created_at   = T.let(DateTime.parse(record["created_at"]), DateTime)
        @creator_id   = T.let(record["creator_id"].to_i, Integer)
        @file_ext     = T.let(T.must(record["file_ext"]), String)
        @file_name    = T.let(T.must(record["file_name"]), String)
        @file_size    = T.let(record["file_size"].to_i, Integer)
        @id           = T.let(record["id"].to_i, Integer)
        @image_height = T.let(record["image_height"].to_i, Integer)
        @image_width  = T.let(record["image_width"].to_i, Integer)
        @md5          = T.let(T.must(record["md5"]), String)
        @post_id      = T.let(record["post_id"].to_i, Integer)
        @reason       = T.let(T.must(record["reason"]), String)
        @source       = T.let(T.must(record["source"]).empty? ? nil : record["source"], T.nilable(String))
        @status       = T.let(T.must(record["status"]), String)
        @updated_at   = T.let(DateTime.parse(record["updated_at"]), DateTime)
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          approver_id:  @approver_id,
          created_at:   @created_at,
          creator_id:   @creator_id,
          file_ext:     @file_ext,
          file_name:    @file_name,
          file_size:    @file_size,
          id:           @id,
          image_height: @image_height,
          image_width:  @image_width,
          md5:          @md5,
          post_id:      @post_id,
          reason:       @reason,
          source:       @source,
          status:       @status,
          updated_at:   @updated_at,
        }.to_json
      end
    end
  end
end
