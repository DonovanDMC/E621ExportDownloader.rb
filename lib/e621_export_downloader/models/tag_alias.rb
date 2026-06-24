# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class TagAlias
      extend(T::Sig)

      sig { returns(String) }
      attr_reader(:antecedent_name)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:approver_id)

      sig { returns(String) }
      attr_reader(:consequent_name)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:created_at)

      # sig { returns(T.nilable(Integer)) }
      # attr_reader(:creator_id)

      sig { returns(Integer) }
      attr_reader(:down_votes)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:forum_post_id)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:forum_topic_id)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(Integer) }
      attr_reader(:meh_votes)

      sig { returns(Integer) }
      attr_reader(:post_count)

      sig { returns(String) }
      attr_reader(:reason)

      sig { returns(String) }
      attr_reader(:status)

      sig { returns(Integer) }
      attr_reader(:up_votes)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:updated_at)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record          = T.let(record, T::Hash[String, String])
        @antecedent_name = T.let(T.must(record["antecedent_name"]), String)
        @approver_id     = T.let(T.must(record["approver_id"]).empty? ? nil : record["approver_id"].to_i, T.nilable(Integer))
        @consequent_name = T.let(T.must(record["consequent_name"]), String)
        @created_at      = T.let(T.must(record["created_at"]).empty? ? nil : DateTime.parse(record["created_at"]), T.nilable(DateTime))
        # @creator_id      = T.let(T.must(record["creator_id"]).empty? ? nil : record["creator_id"].to_i, T.nilable(Integer))
        @down_votes      = T.let(record["down_votes"].to_i, Integer)
        @forum_post_id   = T.let(T.must(record["forum_post_id"]).empty? ? nil : record["forum_post_id"].to_i, T.nilable(Integer))
        @forum_topic_id  = T.let(T.must(record["forum_topic_id"]).empty? ? nil : record["forum_topic_id"].to_i, T.nilable(Integer))
        @id              = T.let(record["id"].to_i, Integer)
        @meh_votes       = T.let(record["meh_votes"].to_i, Integer)
        @post_count      = T.let(record["post_count"].to_i, Integer)
        @reason          = T.let(T.must(record["reason"]), String)
        @status          = T.let(T.must(record["status"]), String)
        @up_votes        = T.let(record["up_votes"].to_i, Integer)
        @updated_at      = T.let(T.must(record["updated_at"]).empty? ? nil : DateTime.parse(record["updated_at"]), T.nilable(DateTime))
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          antecedent_name: @antecedent_name,
          approver_id:     @approver_id,
          consequent_name: @consequent_name,
          created_at:      @created_at,
          # creator_id:      @creator_id,
          down_votes:      @down_votes,
          forum_post_id:   @forum_post_id,
          forum_topic_id:  @forum_topic_id,
          id:              @id,
          meh_votes:       @meh_votes,
          post_count:      @post_count,
          reason:          @reason,
          status:          @status,
          up_votes:        @up_votes,
          updated_at:      @updated_at,
        }.to_json
      end
    end
  end
end
