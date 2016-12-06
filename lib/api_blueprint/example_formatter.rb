module ApiBlueprintFormatter
  class ExampleFormatter
    attr_reader :example_metadata

    def initialize(example_description, example_metadata)
      @example_description, @example_metadata = example_description, example_metadata
    end

    def format
      out = ''
      out << "+ Request #{example_description}\n" \
      "\n" \
      "        #{example_metadata[:request][:parameters]}\n" \
      "\n" \
      "        Location: #{example_metadata[:location]}\n" \
      "        Source code:\n" \
      "\n" \
      "#{indent_lines(8, example_metadata[:source])}\n" \
      "\n"

      out << "+ Response #{example_metadata[:response][:status]} (#{example_metadata[:request][:format]})\n" \
      "\n" \
      "        #{example_metadata[:response][:body]}\n" \
      "\n"
    end

    def example_description
      @example_description.gsub(/[\[\]]/, '['=>'{', ']'=>'}')
    end

    private

    def indent_lines(number_of_spaces, string)
      string
          .split("\n")
          .map { |a| a.prepend(' ' * number_of_spaces) }
          .join("\n")
    end
  end
end