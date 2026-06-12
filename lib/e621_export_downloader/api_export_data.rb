# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  class APIExportData < T::Struct
    const(:file_name, String)
    const(:file_size, Integer)
    const(:name, Types)
    const(:updated_at, String)
    const(:url, String)
  end
end
