# frozen_string_literal: true
# typed: true

module E621
  module CsvImportable
    extend(T::Sig)

    sig { params(csv_path: String).returns(T.untyped) }
    def import_from_csv(csv_path)
      model = T.unsafe(self)
      headers = File.open(csv_path, "rb", &:readline).chomp
      columns = headers.split(",").map { |h| model.connection.quote_column_name(h.strip) }.join(", ")
      raw = model.connection.raw_connection
      raw.copy_data("COPY #{model.quoted_table_name} (#{columns}) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)") do
        File.open(csv_path, "rb") do |f|
          raw.put_copy_data(f.read(65_536)) until f.eof?
        end
      end
    end
  end
end
