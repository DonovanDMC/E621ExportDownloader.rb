# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class TagAlias < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.tag_aliases"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::TagAlias).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::TagAlias]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:              record.id,
        antecedent_name: record.antecedent_name,
        approver_id:     record.approver_id,
        consequent_name: record.consequent_name,
        created_at:      record.created_at,
        # creator_id:      record.creator_id,
        down_votes:      record.down_votes,
        forum_post_id:   record.forum_post_id,
        forum_topic_id:  record.forum_topic_id,
        meh_votes:       record.meh_votes,
        post_count:      record.post_count,
        reason:          record.reason,
        status:          record.status,
        up_votes:        record.up_votes,
        updated_at:      record.updated_at,
      }
    end)
  end
end
