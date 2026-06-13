# frozen_string_literal: true
# typed: true

require("active_record")

module E621
  class RowCount < ActiveRecord::Base
    extend(T::Sig)

    self.table_name = "e621.row_counts"
    self.primary_key = "table_name"
    self.record_timestamps = false

    sig { params(table_name: String).returns(Integer) }
    def self.[](table_name)
      find_by(table_name: table_name)&.count || 0
    end

    sig { params(table_name: String, count: Integer).returns(T.untyped) }
    def self.set(table_name, count)
      upsert({ table_name: table_name, count: count }, unique_by: :table_name)
    end

    sig { params(table_name: String, by: Integer).returns(T.untyped) }
    def self.increment(table_name, by)
      where(table_name: table_name).update_all("count = count + #{by.to_i}")
    end
  end
end
