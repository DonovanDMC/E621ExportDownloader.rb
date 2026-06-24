# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class BulkUpdateRequest < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.bulk_update_requests"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::BulkUpdateRequest).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::BulkUpdateRequest]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:             record.id,
        approver_id:    record.approver_id,
        created_at:     record.created_at,
        down_votes:     record.down_votes,
        forum_topic_id: record.forum_topic_id,
        meh_votes:      record.meh_votes,
        script:         record.script,
        status:         record.status,
        title:          record.title,
        up_votes:       record.up_votes,
        updated_at:     record.updated_at,
        user_id:        record.user_id,
      }
    end)
  end
end
