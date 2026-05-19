# frozen_string_literal: true

require("active_job")

module E621ExportDownloader
  module Serializers
    class ActiveJob < ::ActiveJob::Serializers::ObjectSerializer
      def serialize?(argument)
        argument.is_a?(Types)
      end

      def serialize(argument)
        super("value" => argument.serialize)
      end

      def deserialize(argument)
        Types.const_get(argument["value"].split(/[_\s-]/).map(&:capitalize).join)
      end
    end
  end
end
