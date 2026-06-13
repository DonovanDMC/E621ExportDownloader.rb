# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class PostVersion
      extend(T::Sig)

      sig { returns(T::Array[String]) }
      attr_reader(:added_locked_tags)

      sig { returns(T::Array[String]) }
      attr_reader(:added_tags)

      sig { returns(T.nilable(String)) }
      attr_reader(:description)

      sig { returns(T::Boolean) }
      attr_reader(:description_changed)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(T.nilable(String)) }
      attr_reader(:locked_tags)

      sig { returns(T::Boolean) }
      attr_reader(:parent_changed)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:parent_id)

      sig { returns(Integer) }
      attr_reader(:post_id)

      sig { returns(T.nilable(String)) }
      attr_reader(:rating)

      sig { returns(T::Boolean) }
      attr_reader(:rating_changed)

      sig { returns(T.nilable(String)) }
      attr_reader(:reason)

      sig { returns(T::Array[String]) }
      attr_reader(:removed_locked_tags)

      sig { returns(T::Array[String]) }
      attr_reader(:removed_tags)

      sig { returns(T.nilable(String)) }
      attr_reader(:source)

      sig { returns(T::Boolean) }
      attr_reader(:source_changed)

      sig { returns(T.nilable(String)) }
      attr_reader(:tags)

      sig { returns(DateTime) }
      attr_reader(:updated_at)

      sig { returns(Integer) }
      attr_reader(:updater_id)

      sig { returns(Integer) }
      attr_reader(:version)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record              = T.let(record, T::Hash[String, String])
        inner                = T.must(T.must(record["added_locked_tags"])[1..-2])
        @added_locked_tags   = T.let(inner.empty? ? [] : inner.split(","), T::Array[String])
        inner                = T.must(T.must(record["added_tags"])[1..-2])
        @added_tags          = T.let(inner.empty? ? [] : inner.split(","), T::Array[String])
        @description         = T.let(T.must(record["description"]).empty? ? nil : record["description"], T.nilable(String))
        @description_changed = T.let(record["description_changed"] == "t", T::Boolean)
        @id                  = T.let(record["id"].to_i, Integer)
        @locked_tags         = T.let(T.must(record["locked_tags"]).empty? ? nil : record["locked_tags"], T.nilable(String))
        @parent_changed      = T.let(record["parent_changed"] == "t", T::Boolean)
        @parent_id           = T.let(T.must(record["parent_id"]).empty? ? nil : record["parent_id"].to_i, T.nilable(Integer))
        @post_id             = T.let(record["post_id"].to_i, Integer)
        @rating              = T.let(T.must(record["rating"]).empty? ? nil : record["rating"], T.nilable(String))
        @rating_changed      = T.let(record["rating_changed"] == "t", T::Boolean)
        @reason              = T.let(T.must(record["reason"]).empty? ? nil : record["reason"], T.nilable(String))
        inner                = T.must(T.must(record["removed_locked_tags"])[1..-2])
        @removed_locked_tags = T.let(inner.empty? ? [] : inner.split(","), T::Array[String])
        inner                = T.must(T.must(record["removed_tags"])[1..-2])
        @removed_tags        = T.let(inner.empty? ? [] : inner.split(","), T::Array[String])
        @source              = T.let(T.must(record["source"]).empty? ? nil : record["source"], T.nilable(String))
        @source_changed      = T.let(record["source_changed"] == "t", T::Boolean)
        @tags                = T.let(T.must(record["tags"]).empty? ? nil : record["tags"], T.nilable(String))
        @updated_at          = T.let(DateTime.parse(record["updated_at"]), DateTime)
        @updater_id          = T.let(record["updater_id"].to_i, Integer)
        @version             = T.let(record["version"].to_i, Integer)
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          added_locked_tags:   @added_locked_tags,
          added_tags:          @added_tags,
          description:         @description,
          description_changed: @description_changed,
          id:                  @id,
          locked_tags:         @locked_tags,
          parent_changed:      @parent_changed,
          parent_id:           @parent_id,
          post_id:             @post_id,
          rating:              @rating,
          rating_changed:      @rating_changed,
          reason:              @reason,
          removed_locked_tags: @removed_locked_tags,
          removed_tags:        @removed_tags,
          source:              @source,
          source_changed:      @source_changed,
          tags:                @tags,
          updated_at:          @updated_at,
          updater_id:          @updater_id,
          version:             @version,
        }.to_json
      end
    end
  end
end
