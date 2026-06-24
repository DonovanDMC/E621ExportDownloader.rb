# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class BulkUpdateRequest
      extend(T::Sig)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:approver_id)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(Integer) }
      attr_reader(:down_votes)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:forum_topic_id)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(Integer) }
      attr_reader(:meh_votes)

      sig { returns(String) }
      attr_reader(:script)

      sig { returns(String) }
      attr_reader(:status)

      sig { returns(T.nilable(String)) }
      attr_reader(:title)

      sig { returns(Integer) }
      attr_reader(:up_votes)

      sig { returns(DateTime) }
      attr_reader(:updated_at)

      sig { returns(Integer) }
      attr_reader(:user_id)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record         = T.let(record, T::Hash[String, String])
        @approver_id    = T.let(T.must(record["approver_id"]).empty? ? nil : record["approver_id"].to_i, T.nilable(Integer))
        @created_at     = T.let(DateTime.parse(record["created_at"]), DateTime)
        @down_votes     = T.let(record["down_votes"].to_i, Integer)
        @forum_topic_id = T.let(T.must(record["forum_topic_id"]).empty? ? nil : record["forum_topic_id"].to_i, T.nilable(Integer))
        @id             = T.let(record["id"].to_i, Integer)
        @meh_votes      = T.let(record["meh_votes"].to_i, Integer)
        @script         = T.let(T.must(record["script"]), String)
        @status         = T.let(T.must(record["status"]), String)
        @title          = T.let(T.must(record["title"]).empty? ? nil : record["title"], T.nilable(String))
        @up_votes       = T.let(record["up_votes"].to_i, Integer)
        @updated_at     = T.let(DateTime.parse(record["updated_at"]), DateTime)
        @user_id        = T.let(record["user_id"].to_i, Integer)
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          approver_id:    @approver_id,
          created_at:     @created_at,
          down_votes:     @down_votes,
          forum_topic_id: @forum_topic_id,
          id:             @id,
          meh_votes:      @meh_votes,
          script:         @script,
          status:         @status,
          title:          @title,
          up_votes:       @up_votes,
          updated_at:     @updated_at,
          user_id:        @user_id,
        }.to_json
      end
    end
  end
end
