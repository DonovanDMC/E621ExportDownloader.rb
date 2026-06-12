# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class Pool < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.pools"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::Pool).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::Pool]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:          record.id,
        category:    record.category,
        created_at:  record.created_at,
        creator_id:  record.creator_id,
        description: record.description,
        is_active:   record.is_active,
        name:        record.name,
        post_ids:    record.post_ids,
        updated_at:  record.updated_at,
      }
    end)
  end
end
