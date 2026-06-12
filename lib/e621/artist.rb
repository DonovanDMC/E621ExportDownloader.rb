# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class Artist < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.artists"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::Artist).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::Artist]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:             record.id,
        created_at:     record.created_at,
        creator_id:     record.creator_id,
        group_name:     record.group_name,
        is_active:      record.is_active,
        is_locked:      record.is_locked,
        linked_user_id: record.linked_user_id,
        name:           record.name,
        other_names:    record.other_names,
        updated_at:     record.updated_at,
        urls:           record.urls,
      }
    end)
  end
end
