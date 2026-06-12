# frozen_string_literal: true
# typed: true

require("active_record")

module E621
  class PostReplacement < ActiveRecord::Base
    extend(T::Sig)

    self.table_name = "e621.post_replacements"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::PostReplacement).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::PostReplacement]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:           record.id,
        approver_id:  record.approver_id,
        created_at:   record.created_at,
        creator_id:   record.creator_id,
        file_ext:     record.file_ext,
        file_name:    record.file_name,
        file_size:    record.file_size,
        image_height: record.image_height,
        image_width:  record.image_width,
        md5:          record.md5,
        post_id:      record.post_id,
        reason:       record.reason,
        source:       record.source,
        status:       record.status,
        updated_at:   record.updated_at,
      }
    end)
  end
end
