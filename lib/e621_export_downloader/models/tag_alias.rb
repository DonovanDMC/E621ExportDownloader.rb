# frozen_string_literal: true
# typed: strict

module E621ExportDownloader
  module Models
    class TagAlias
      extend(T::Sig)

      sig { returns(String) }
      attr_reader(:antecedent_name)

      sig { returns(String) }
      attr_reader(:consequent_name)

      sig { returns(T.nilable(DateTime)) }
      attr_reader(:created_at)

      sig { returns(Integer) }
      attr_reader(:id)

      sig { returns(String) }
      attr_reader(:status)

      sig { params(record: T::Hash[String, String]).void }
      def initialize(record)
        @record = T.let(record, T::Hash[String, String])
        @antecedent_name = T.let(T.must(record["antecedent_name"]), String)
        @consequent_name = T.let(T.must(record["consequent_name"]), String)
        @created_at = T.let(T.must(record["created_at"]).empty? ? nil : DateTime.parse(record["created_at"]), T.nilable(DateTime))
        @id = T.let(record["id"].to_i, Integer)
        @status = T.let(T.must(record["status"]), String)
      end

      sig { params(_args: T.untyped).returns(String) }
      def to_json(*_args)
        {
          antecedent_name: @antecedent_name,
          consequent_name: @consequent_name,
          created_at:      @created_at,
          id:              @id,
          status:          @status,
        }.to_json
      end
    end
  end
end
