# frozen_string_literal: true

module E621ExportDownloader
  class Types < T::Enum
    enums do
      Pools = new
      Posts = new
      TagAliases = new
      TagImplications = new
      Tags = new
      WikiPages = new
    end
  end
end
