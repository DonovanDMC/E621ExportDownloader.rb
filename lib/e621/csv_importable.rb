# frozen_string_literal: true
# typed: true

require("csv")

module E621
  module CsvImportable
    extend(T::Sig)

    sig { returns(Integer) }
    def row_count
      E621::RowCount[T.unsafe(self).table_name.split(".").last]
    end

    sig { params(count: Integer).returns(T.untyped) }
    def row_count=(count)
      E621::RowCount.set(T.unsafe(self).table_name.split(".").last, count)
    end

    sig { params(csv_path: String).returns(Integer) }
    def import_from_csv(csv_path)
      model = T.unsafe(self)
      csv_headers = File.open(csv_path, "rb", &:readline).chomp.split(",").map(&:strip)
      columns = csv_headers.map { |h| model.connection.quote_column_name(h) }.join(", ")

      count = 0
      raw = model.connection.raw_connection
      raw.copy_data("COPY #{model.quoted_table_name} (#{columns}) FROM STDIN WITH (FORMAT CSV)") do
        CSV.foreach(csv_path, headers: true) do |row|
          raw.put_copy_data(CSV.generate_line(T.cast(row, CSV::Row).fields))
          count += 1
        end
      end
      self.row_count = count
      count
    end
  end
end
