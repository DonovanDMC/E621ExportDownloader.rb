# frozen_string_literal: true
# typed: true

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

    # Loads a CSV export into this model's table via PostgreSQL COPY.
    #
    # The file's raw bytes are streamed straight into COPY's native CSV parser
    # (only the header line is read, for the column list) rather than parsing
    # each row into a CSV::Row and re-serializing it in Ruby. That avoids a
    # full single-threaded parse + re-encode of every row and preserves the
    # exact bytes of fields containing embedded newlines/quotes. The row count
    # is taken from COPY itself (PG::Result#cmd_tuples).
    #
    # truncate:         empty the table before loading (full reload).
    # recreate_indexes: drop every secondary (non-PK, non-constraint) index
    #                   before the COPY and rebuild it afterward. Building the
    #                   GIN/btree indexes once over the finished table is far
    #                   cheaper than maintaining them row-by-row during COPY,
    #                   and CREATE INDEX can use parallel workers.
    #
    # Physical-storage policy (UNLOGGED) and session tuning
    # (maintenance_work_mem, max_parallel_maintenance_workers, ...) are the
    # caller's responsibility — set them around this call.
    sig do
      params(
        csv_path:         String,
        truncate:         T::Boolean,
        recreate_indexes: T::Boolean,
        chunk_bytes:      Integer,
      ).returns(Integer)
    end
    def import_from_csv(csv_path, truncate: false, recreate_indexes: false, chunk_bytes: 1 << 20)
      model = T.unsafe(self)
      indexes = recreate_indexes ? secondary_index_definitions : {}

      model.connection.execute("TRUNCATE #{model.quoted_table_name}") if truncate
      indexes.each_key { |name| model.connection.execute("DROP INDEX IF EXISTS #{name}") }

      count = copy_csv(csv_path, chunk_bytes: chunk_bytes)

      indexes.each_value { |ddl| model.connection.execute(ddl) }
      self.row_count = count
      count
    end

    private

    sig { params(csv_path: String, chunk_bytes: Integer).returns(Integer) }
    def copy_csv(csv_path, chunk_bytes:)
      model = T.unsafe(self)
      header = File.open(csv_path, "rb", &:readline)
      columns = header.chomp.split(",").map { |h| model.connection.quote_column_name(h.strip) }.join(", ")

      raw = model.connection.raw_connection
      result = raw.copy_data("COPY #{model.quoted_table_name} (#{columns}) FROM STDIN WITH (FORMAT CSV)") do
        File.open(csv_path, "rb") do |io|
          io.readline # skip header row
          while (chunk = io.read(chunk_bytes))
            raw.put_copy_data(chunk)
          end
        end
      end
      result.cmd_tuples
    end

    # Every non-primary-key, non-constraint-backed index on the table, paired
    # with the DDL needed to recreate it.
    sig { returns(T::Hash[String, String]) }
    def secondary_index_definitions
      model = T.unsafe(self)
      conn = model.connection
      sql = <<~SQL
        SELECT i.indexrelid::regclass::text AS name,
               pg_get_indexdef(i.indexrelid)  AS ddl
        FROM pg_index i
        WHERE i.indrelid = #{conn.quote(model.quoted_table_name)}::regclass
          AND NOT i.indisprimary
          AND NOT EXISTS (
            SELECT 1 FROM pg_constraint c WHERE c.conindid = i.indexrelid
          )
      SQL
      conn.exec_query(sql).to_h { |r| [r["name"], r["ddl"]] }
    end
  end
end
