# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class PostVersion < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.post_versions"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::PostVersion).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::PostVersion]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:                  record.id,
        post_id:             record.post_id,
        added_locked_tags:   record.added_locked_tags,
        added_tags:          record.added_tags,
        description:         record.description,
        description_changed: record.description_changed,
        locked_tags:         record.locked_tags,
        parent_changed:      record.parent_changed,
        parent_id:           record.parent_id,
        rating:              record.rating,
        rating_changed:      record.rating_changed,
        reason:              record.reason,
        removed_locked_tags: record.removed_locked_tags,
        removed_tags:        record.removed_tags,
        source:              record.source,
        source_changed:      record.source_changed,
        tags:                record.tags,
        updated_at:          record.updated_at,
        updater_id:          record.updater_id,
        version:             record.version,
      }
    end)
  end
end
