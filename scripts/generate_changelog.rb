#!/usr/bin/env ruby
# frozen_string_literal: true

require("date")

def categorize(subject)
  case subject
  when /\Aadd /i    then "Added"
  when /\Afix /i    then "Fixed"
  when /\Aoptimize /i, /\Arefactor /i, /\Aupdate /i then "Changed"
  end
end

shas = `git log --follow --format="%H" -- lib/e621_export_downloader/version.rb`.strip.split("\n")

entries = shas.map do |sha|
  subject      = `git log -1 --format="%s" #{sha}`.strip
  date_str     = `git log -1 --format="%ai" #{sha}`.strip
  body         = `git log -1 --format="%b" #{sha}`.strip
  version_file = `git show #{sha}:lib/e621_export_downloader/version.rb`
  version      = version_file.match(/VERSION = "([^"]+)"/)[1]
  date         = Date.parse(date_str).strftime("%Y-%m-%d")
  section      = categorize(subject)

  { version: version, date: date, section: section, subject: subject, body: body }
end

changelog = +"# Changelog\n"

entries.each do |e|
  changelog << "\n## [#{e[:version]}] - #{e[:date]}\n"

  section = e[:section]
  if section
    changelog << "\n### #{section}\n"
    changelog << "- #{e[:subject]}"

    unless e[:body].empty?
      refs = e[:body].scan(/(?:from|pending):\s*\S+/).join(", ")
      changelog << " (#{refs})" unless refs.empty?
    end

    changelog << "\n"
  else
    changelog << "\n_#{e[:subject]}_\n"
  end
end

File.write("CHANGELOG.md", changelog)
puts("Generated CHANGELOG.md")
