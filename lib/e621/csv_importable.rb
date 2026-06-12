# frozen_string_literal: true
# typed: true

module E621
  module CsvImportable
    extend(T::Sig)

    sig { params(csv_path: String).returns(T.untyped) }
    def import_from_csv(csv_path)
      raw = T.unsafe(self).connection.raw_connection
      raw.copy_data("COPY #{T.unsafe(self).quoted_table_name} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)") do
        File.open(csv_path, "rb") do |f|
          raw.put_copy_data(f.read(65_536)) until f.eof?
        end
      end
    end
  end
end
