# frozen_string_literal: true

require("rails/generators")
require("rails/generators/active_record")

module E621ExportDownloader
  #
  # Rails generator used for setting up E621ExportDownloader tables in a Rails application.
  # Run it with +bin/rails g e621_export_downloader:install+ in your console.
  #
  class InstallGenerator < Rails::Generators::Base
    include(ActiveRecord::Generators::Migration)

    TEMPLATES = File.join(File.dirname(__FILE__), "templates")
    source_paths << TEMPLATES

    class_option(:schema, type: :string, default: "e621",
                 desc: "Schema or prefix name for the e621 tables")
    class_option(:table_format, type: :string, default: "schema",
                 desc: "Table reference format: 'schema' uses a PostgreSQL schema (e621.artists), 'prefix' uses a name prefix (e621_artists)")

    def validate_options
      return if %w[schema prefix].include?(options[:table_format])
      abort("--table-format must be 'schema' or 'prefix', got '#{options[:table_format]}'")
    end

    def create_migration_file
      migration_template("migrations/create_e621_tables.rb.erb", File.join(db_migrate_path, "create_e621_tables.rb"))
    end

    def create_initializer
      template("initializers/e621_models.rb.erb", "config/initializers/e621_models.rb")
    end

    private

    def schema
      options[:schema]
    end

    def use_schema?
      options[:table_format] == "schema"
    end

    def table_ref(name)
      use_schema? ? "\"#{schema}.#{name}\"" : ":#{schema}_#{name}"
    end

    def table_name_for(name)
      use_schema? ? "#{schema}.#{name}" : "#{schema}_#{name}"
    end

    def migration_version
      "[#{ActiveRecord::VERSION::STRING.to_f}]"
    end
  end
end
