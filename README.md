# E621 Export Downloader

A utility for downloading and parsing e621's exports.

## Installation

```bash
gem install e621_export_downloader
```

Or add it to your Gemfile:

```bash
bundle add e621_export_downloader
```

## Usage

```ruby
require("e621_export_downloader")

client = E621ExportDownloader::Client.new

# configure options after creation
client.config do |c|
  c.cache = true  # keep export files after reading, defaults to false
end

# or pass an Options struct directly
client = E621ExportDownloader::Client.new(
  E621ExportDownloader::Client::Options.new(cache: true)
)

# get the export for a type — resolves the latest available export from the e621 API
# types: artists, bulk_update_requests, pools, posts, post_replacements, post_versions, tag_aliases, tag_implications, tags, wiki_pages
export = client.get("posts")

# get a deferred export — the API call is made lazily on first use
deferred = client.get_deferred("posts")

# get raw metadata for all exports from the e621 API
# returns an Array of E621ExportDownloader::APIExportData: { file_name, file_size, name, updated_at, url }
data = client.get_data

# access the metadata for this specific export: { file_name, file_size, name, updated_at, url }
export.data

# check if the export exists
exists = export.exists?

# download the export, returns the file path — not required before reading
# if you move or remove the file do not reuse the export object
file = export.download

# delete the downloaded file, if it exists
export.delete

# get all of the records as a single array, DO NOT use this for large exports, arrays with millions of items do not perform well and will likely crash your process!
# (not to mention that the posts export is more than 5 gigabytes)
records = export.read_all

# read streams the CSV and yields each parsed record together with the total row count
# this is the recommended approach for large exports (the posts export exceeds 5 GB)
export.read do |record, total|
  # record is an E621ExportDownloader::Models::Post instance
end
```

## Replace or extend a parser

```ruby
require("e621_export_downloader")

client = E621ExportDownloader::Client.new

client.config do |c|
  c.parsers do |p|
    # replace a parser with a custom proc that receives the raw CSV row hash
    # return nil to skip a record
    p.posts = proc do |record|
      post = E621ExportDownloader::Models::Post.new(record)
      # attach extra data or wrap in your own class
      post
    end
  end
end
```

Available parser keys: `artists`, `bulk_update_requests`, `pools`, `posts`, `post_replacements`, `post_versions`, `tag_aliases`, `tag_implications`, `tags`, `wiki_pages`

## Models

Each export type is parsed into a corresponding model class:

| Export type            | Model class                                           |
|------------------------|-------------------------------------------------------|
| `artists`              | `E621ExportDownloader::Models::Artist`                |
| `bulk_update_requests` | `E621ExportDownloader::Models::BulkUpdateRequest`     |
| `pools`                | `E621ExportDownloader::Models::Pool`                  |
| `posts`                | `E621ExportDownloader::Models::Post`                  |
| `post_replacements`    | `E621ExportDownloader::Models::PostReplacement`       |
| `post_versions`        | `E621ExportDownloader::Models::PostVersion`           |
| `tag_aliases`          | `E621ExportDownloader::Models::TagAlias`              |
| `tag_implications`     | `E621ExportDownloader::Models::TagImplication`        |
| `tags`                 | `E621ExportDownloader::Models::Tag`                   |
| `wiki_pages`           | `E621ExportDownloader::Models::WikiPage`              |

## CLI

```bash
# get export metadata from the e621 API as a JSON array
# outputs { file_name, file_size, name, updated_at, url }[] with no trailing newline
e621-export-downloader data

# check if an export exists
# outputs "true" or "false" with no trailing newline
e621-export-downloader exists posts

# download an export
# outputs the path to the downloaded file with no trailing newline
e621-export-downloader download posts

# read an export as individual JSON lines
# outputs each record as a JSON object on its own line
e621-export-downloader read posts

# read an export as a JSON array
# streams the CSV internally, so it is safe to use with large exports
e621-export-downloader read-all posts

e621-export-downloader --help
e621-export-downloader --version
e621-export-downloader --cache     # enable caching
e621-export-downloader --no-cache  # disable caching (default)
```

## ActiveJob Integration

`E621ExportDownloader::Serializers::ActiveJob` allows `E621ExportDownloader::Types` values to be passed as ActiveJob arguments.

In a **Rails app** the serializer is registered automatically — no extra setup needed.

In a **non-Rails app** using ActiveJob standalone, register it manually after loading both gems:

```ruby
require("activejob")
require("e621_export_downloader")
require("e621_export_downloader/serializers/active_job")

ActiveJob::Serializers.add_serializers(E621ExportDownloader::Serializers::ActiveJob)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DonovanDMC/E621ExportDownloader.rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
