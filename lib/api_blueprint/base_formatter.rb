module ApiBlueprintFormatter
  # Base for other formatters, providing utility methods
  class BaseFormatter
    protected

    def indent_lines(number_of_spaces, string)
      string
        .split("\n")
        .map { |a| a.prepend(' ' * number_of_spaces) }
        .join("\n")
    end

    # Change certain characters that might come up in example names
    # but do not play well with the API specs.
    # Example: 'Test for [value]' -> 'Test for {value}'
    def sanitize_api_identifier(name)
      name.gsub(/[\[\]]/, '[' => '{', ']' => '}')
    end
  end
end
