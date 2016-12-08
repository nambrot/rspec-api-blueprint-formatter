module ApiBlueprintFormatter
  # Parses example metadata for Examples (Request+Response) and outputs
  # markdown in accordance with the API Blueprint spec.
  #
  # Specs:
  #   - https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md#def-request-section
  #   - https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md#response-section
  class ExampleFormatter < BaseFormatter
    attr_reader :example_metadata

    def initialize(example_description, example_metadata)
      @example_description = example_description
      @example_metadata = example_metadata
    end

    def format
      out = ''
      out << format_request
      out << format_response
    end

    def example_description
      sanitize_api_identifier(@example_description)
    end

    private

    def format_request
      "+ Request #{example_description}\n" \
      "\n" \
      "        #{example_metadata[:request][:parameters]}\n" \
      "\n" \
      "        Location: #{example_metadata[:location]}\n" \
      "        Source code:\n" \
      "\n" \
      "#{indent_lines(8, example_metadata[:source])}\n" \
      "\n"
    end

    def format_response
      "+ Response #{example_metadata[:response][:status]} (#{example_metadata[:request][:format]})\n" \
      "\n" \
      "        #{example_metadata[:response][:body]}\n" \
      "\n"
    end
  end
end
