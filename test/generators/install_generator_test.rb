# frozen_string_literal: true

require("minitest/autorun")
require("rails/generators/testing/behavior")
require("rails/generators/testing/assertions")
require("generators/e621_export_downloader/install_generator")

class InstallGeneratorTest < Rails::Generators::TestCase
  tests(E621ExportDownloader::InstallGenerator)
  destination(File.expand_path("../tmp", __dir__))
  setup(:prepare_destination)

  test("creates migration with schema format by default") do
    run_generator
    assert_migration("db/migrate/create_e621_tables.rb") do |content|
      assert_match(/CREATE SCHEMA e621/, content)
      assert_match(/create_table\("e621\.artists"/, content)
    end
  end

  test("creates initializer") do
    run_generator
    assert_file("config/initializers/e621_models.rb") do |content|
      assert_match(%r{require\("e621_export_downloader/active_record_models"\)}, content)
      assert_match(/E621::Artist\s+-\s+e621\.artists/, content)
    end
  end

  test("--schema changes the schema name") do
    run_generator(%w[--schema mydb])
    assert_migration("db/migrate/create_e621_tables.rb") do |content|
      assert_match(/CREATE SCHEMA mydb/, content)
      assert_match(/create_table\("mydb\.artists"/, content)
    end
    assert_file("config/initializers/e621_models.rb") do |content|
      assert_match(/E621::Artist\s+-\s+mydb\.artists/, content)
    end
  end

  test("--table-format prefix omits schema creation and uses prefixed table names") do
    run_generator(%w[--table-format prefix])
    assert_migration("db/migrate/create_e621_tables.rb") do |content|
      assert_no_match(/CREATE SCHEMA/, content)
      assert_match(/create_table\(:e621_artists/, content)
    end
    assert_file("config/initializers/e621_models.rb") do |content|
      assert_match(/E621::Artist\s+-\s+e621_artists/, content)
    end
  end

  test("--schema and --table-format prefix combine") do
    run_generator(%w[--schema mydb --table-format prefix])
    assert_migration("db/migrate/create_e621_tables.rb") do |content|
      assert_no_match(/CREATE SCHEMA/, content)
      assert_match(/create_table\(:mydb_artists/, content)
    end
    assert_file("config/initializers/e621_models.rb") do |content|
      assert_match(/E621::Artist\s+-\s+mydb_artists/, content)
    end
  end
end
