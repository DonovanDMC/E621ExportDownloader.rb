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
  c.cache = true              # keep export files after reading, defaults to true
  c.rewind_on_not_found = 2  # decrease date by one day if no export is found for that date,
                              # provide an integer to limit how many days can be rewound,
                              # `true` is equivalent to `2`, defaults to false
end

# or pass an Options struct directly
client = E621ExportDownloader::Client.new(
  E621ExportDownloader::Client::Options.new(
    cache:              true,
    rewind_on_not_found: 2,
  )
)

# get the helper for interacting with a type of export
# types: pools, posts, tag_aliases, tag_implications, tags, wiki_pages
helper = client.get("posts")
# or use the named shorthand:
helper = client.posts

# get a wrapper for a specific date (time components are ignored)
# using this directly will not trigger rewinding regardless of rewind_on_not_found
export = helper.get(Date.today)

# convenience shorthand on the client — also skips rewinding
export = client.get_posts(Date.today)

# all of the following methods can also be called on the helper with a date argument;
# if rewind_on_not_found is enabled the helper decrements the date by one day until it
# finds an export or exhausts the rewind limit, at which point it raises ResolveError

# check whether the export exists for the date
exists = export.exists?
exists = helper.exists?(Date.today)

# download the export, returns the file path — not required before reading
# if you move or remove the file do not reuse the export object
file = export.download
file = helper.download(Date.today)

# delete the downloaded file, if it exists
export.delete
helper.delete(Date.today)

# get all of the records as a single array, DO NOT use this for large exports, arrays will millions of items do not perform well and will likely crash your process!
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

## Models

Each export type is parsed into a corresponding model class:

| Export type       | Model class                                       |
|-------------------|---------------------------------------------------|
| `pools`           | `E621ExportDownloader::Models::Pool`              |
| `posts`           | `E621ExportDownloader::Models::Post`              |
| `tag_aliases`     | `E621ExportDownloader::Models::TagAlias`          |
| `tag_implications`| `E621ExportDownloader::Models::TagImplication`    |
| `tags`            | `E621ExportDownloader::Models::Tag`               |
| `wiki_pages`      | `E621ExportDownloader::Models::WikiPage`          |

## CLI

```bash
# check if an export exists for a given date; date is optional and defaults to today
# outputs "true" or "false" with no trailing newline
e621-export-downloader exists posts 2024-01-01

# download an export for a given date; date is optional and defaults to today
# outputs the path to the downloaded file with no trailing newline
e621-export-downloader download posts 2024-01-01

# read an export as individual JSON lines; date is optional and defaults to today
# outputs each record as a JSON object on its own line
e621-export-downloader read posts 2024-01-01

# read an export as a JSON array; date is optional and defaults to today
# streams the CSV internally, so it is safe to use with large exports
e621-export-downloader read-all posts 2024-01-01

e621-export-downloader --help
e621-export-downloader --version
e621-export-downloader --cache                    # enable caching (default)
e621-export-downloader --no-cache                 # disable caching
e621-export-downloader --rewind-on-not-found      # enable rewinding (up to 2 days)
e621-export-downloader --rewind-on-not-found 5    # enable rewinding (up to 5 days)
e621-export-downloader --no-rewind-on-not-found   # disable rewinding (default)
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
