# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class Post < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.posts"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::Post).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::Post]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:                record.id,
        approver_id:       record.approver_id,
        bg_color:          record.bg_color,
        change_seq:        record.change_seq,
        comment_count:     record.comment_count,
        created_at:        record.created_at,
        description:       record.description,
        down_score:        record.down_score,
        duration:          record.duration,
        fav_count:         record.fav_count,
        file_ext:          record.file_ext,
        file_size:         record.file_size,
        image_height:      record.image_height,
        image_width:       record.image_width,
        is_deleted:        record.is_deleted,
        is_flagged:        record.is_flagged,
        is_note_locked:    record.is_note_locked,
        is_pending:        record.is_pending,
        is_rating_locked:  record.is_rating_locked,
        is_status_locked:  record.is_status_locked,
        last_commented_at: record.last_commented_at,
        last_noted_at:     record.last_noted_at,
        locked_tags:       record.locked_tags,
        md5:               record.md5,
        parent_id:         record.parent_id,
        rating:            record.rating,
        score:             record.score,
        sources:           record.sources,
        tags:              record.tags,
        up_score:          record.up_score,
        updated_at:        record.updated_at,
        uploader_id:       record.uploader_id,
      }
    end)
  end
end
