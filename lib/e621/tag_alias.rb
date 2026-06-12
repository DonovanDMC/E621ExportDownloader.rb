# frozen_string_literal: true
# typed: true

require("active_record")

module E621
  class TagAlias < ActiveRecord::Base
    extend(T::Sig)

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
        consequent_name: record.consequent_name,
        created_at:      record.created_at,
        status:          record.status,
      }
    end)
  end
end
