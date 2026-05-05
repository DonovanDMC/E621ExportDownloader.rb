# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class Post
      extend(T::Sig)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:approver_id)

      sig { returns(Integer) }
      attr_reader(:change_seq)

      sig { returns(Integer) }
      attr_reader(:comment_count)

      sig { returns(DateTime) }
      attr_reader(:created_at)

      sig { returns(String) }
      attr_reader(:description)

      sig { returns(Integer) }
      attr_reader(:down_score)

      sig { returns(T.nilable(Float)) }
      attr_reader(:duration)

      sig { returns(Integer) }
      attr_reader(:fav_count)

      sig { returns(String) }
      attr_reader(:file_ext)

      sig { returns(Integer) }
      attr_reader(:file_size)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(Integer) }
      attr_reader(:image_height)

      sig { returns(Integer) }
      attr_reader(:image_width)

      sig { returns(T::Boolean) }
      attr_reader(:is_deleted)

      sig { returns(T::Boolean) }
      attr_reader(:is_flagged)

      sig { returns(T::Boolean) }
      attr_reader(:is_note_locked)

      sig { returns(T::Boolean) }
      attr_reader(:is_pending)

      sig { returns(T::Boolean) }
      attr_reader(:is_rating_locked)

      sig { returns(T::Boolean) }
      attr_reader(:is_status_locked)

      sig { returns(String) }
      attr_reader(:locked_tags)

      sig { returns(T.nilable(String)) }
      attr_reader(:md5)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:parent_id)

      sig { returns(String) }
      attr_reader(:rating)

      sig { returns(Integer) }
      attr_reader(:score)

      sig { returns(T::Array[String]) }
      attr_reader(:sources)

      sig { returns(T::Array[String]) }
      attr_reader(:tags)

      sig { returns(Integer) }
      attr_reader(:up_score)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:updated_at)

      sig { returns(T.nilable(Integer)) }
      attr_reader(:uploader_id)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @approver_id = T.let(T.must(record["approver_id"]).empty? ? nil : record["approver_id"].to_i, T.nilable(Integer))
        @change_seq = T.let(record["change_seq"].to_i, Integer)
        @comment_count = T.let(record["comment_count"].to_i, Integer)
        @created_at = T.let(DateTime.parse(record["created_at"]), DateTime)
        @description = T.let(T.must(record["description"]).gsub("\r\n", "\n"), String)
        @down_score = T.let(record["down_score"].to_i, Integer)
        @duration = T.let(T.must(record["duration"]).empty? ? nil : record["duration"].to_f, T.nilable(Float))
        @fav_count = T.let(record["fav_count"].to_i, Integer)
        @file_ext = T.let(T.must(record["file_ext"]), String)
        @file_size = T.let(record["file_size"].to_i, Integer)
        @id = T.let(record["id"].to_i, Integer)
        @image_height = T.let(record["image_height"].to_i, Integer)
        @image_width = T.let(record["image_width"].to_i, Integer)
        @is_deleted = T.let(record["is_deleted"] == "t", T::Boolean)
        @is_flagged = T.let(record["is_flagged"] == "t", T::Boolean)
        @is_note_locked = T.let(record["is_note_locked"] == "t", T::Boolean)
        @is_pending = T.let(record["is_pending"] == "t", T::Boolean)
        @is_rating_locked = T.let(record["is_rating_locked"] == "t", T::Boolean)
        @is_status_locked = T.let(record["is_rating_locked"] == "t", T::Boolean)
        @locked_tags = T.let(T.must(record["locked_tags"]), String)
        @md5 = T.let(T.must(record["md5"]).empty? ? nil : record["md5"], T.nilable(String))
        @parent_id = T.let(T.must(record["parent_id"]).empty? ? nil : record["parent_id"].to_i, T.nilable(Integer))
        @rating = T.let(T.must(record["rating"]), String)
        @score = T.let(record["score"].to_i, Integer)
        @sources = T.let(T.must(record["source"]).gsub("\r\n", "\n").split("\n"), T::Array[String])
        @tags = T.let(T.must(record["tag_string"]).split, T::Array[String])
        @up_score = T.let(record["up_score"].to_i, Integer)
        @updated_at = T.let(T.must(record["updated_at"]).empty? ? nil : DateTime.parse(record["updated_at"]), T.nilable(DateTime))
        @uploader_id = T.let(T.must(record["uploader_id"]).empty? ? nil : record["uploader_id"].to_i, T.nilable(Integer))
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          approver_id:      @approver_id,
          change_seq:       @change_seq,
          comment_count:    @comment_count,
          created_at:       @created_at,
          description:      @description,
          down_score:       @down_score,
          duration:         @duration,
          fav_count:        @fav_count,
          file_ext:         @file_ext,
          file_size:        @file_size,
          id:               @id,
          image_height:     @image_height,
          image_width:      @image_width,
          is_deleted:       @is_deleted,
          is_flagged:       @is_flagged,
          is_note_locked:   @is_note_locked,
          is_pending:       @is_pending,
          is_rating_locked: @is_rating_locked,
          is_status_locked: @is_status_locked,
          locked_tags:      @locked_tags,
          md5:              @md5,
          parent_id:        @parent_id,
          rating:           @rating,
          score:            @score,
          sources:          @sources,
          tags:             @tags,
          up_score:         @up_score,
          updated_at:       @updated_at,
          uploader_id:      @uploader_id,
        }.to_json
      end
    end
  end
end
