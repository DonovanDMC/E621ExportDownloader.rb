# frozen_string_literal: true
# typed: true

require("active_record")
require_relative("csv_importable")

module E621
  class WikiPage < ActiveRecord::Base
    extend(T::Sig)
    extend(E621::CsvImportable)

    self.table_name = "e621.wiki_pages"
    self.record_timestamps = false

    sig { params(record: E621ExportDownloader::Models::WikiPage).returns(T.untyped) }
    def self.upsert_from_export(record)
      upsert(attributes_from_export(record))
    end

    sig { params(records: T::Array[E621ExportDownloader::Models::WikiPage]).returns(T.untyped) }
    def self.upsert_all_from_export(records)
      upsert_all(records.map { |r| attributes_from_export(r) })
    end

    private_class_method(def self.attributes_from_export(record)
      {
        id:          record.id,
        body:        record.body,
        created_at:  record.created_at,
        creator_id:  record.creator_id,
        is_locked:   record.is_locked,
        title:       record.title,
        updated_at:  record.updated_at,
        uploader_id: record.uploader_id,
      }
    end)
  end
end
