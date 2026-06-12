# frozen_string_literal: true
# typed: true

require("active_record")

module E621
  class BulkUpdateRequest < ActiveRecord::Base
    extend(T::Sig)

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
        forum_topic_id: record.forum_topic_id,
        script:         record.script,
        status:         record.status,
        title:          record.title,
        updated_at:     record.updated_at,
        user_id:        record.user_id,
      }
    end)
  end
end
