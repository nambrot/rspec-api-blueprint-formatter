module ApiBlueprintFormatter
  # Parses example metadata for Actions and outputs markdown in
  # accordance with the API Blueprint spec.
  #
  # Spec: https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md#def-action-section
  class ActionFormatter < BaseFormatter
    attr_reader :action_metadata, :action_name

    def initialize(action_name, action_metadata)
      @action_name = action_name
      @action_metadata = action_metadata
      @parameters = action_metadata[:parameters] || []
    end

    def format
      output = []
      output << "## #{action_name}"
      output << ''
      output << action_metadata[:description].to_s
      output << ''
      output += format_parameters
      output << ''

      output.join("\n")
    end

    private

    def format_parameters
      return [] if @parameters.empty?

      output = ['']
      output << '+ Parameters'
      @parameters.each_pair do |param, data|
        output += format_param(param, data)
      end
      output << ''

          output
    end

    def format_param(param, data)
      out = []
      out << indent_lines(4, action_header(param, data))

      if multiline_description(param)
        out << ''
        out << indent_lines(8, data[:description])
        out << ''
      end

      out << indent_lines(8, "+ Default: #{data[:default]}") if data[:default]
      out += format_members(param)

      out
    end

    def multiline_description(param)
      members(param).size > 0
    end

    def action_header(param, data)
      param_signature = "#{param}#{param_attributes_string(data)}"
      multiline_description = !members(param).empty?

      header = "+ #{param_signature}"
      header += " - #{data[:description]}" unless multiline_description
      header
    end

    def param_attributes_string(data)
      optional = data[:optional] ? 'optional' : nil
      param_attributes = [data[:type], optional].compact

      " (#{param_attributes.join(', ')})" unless param_attributes.empty?
    end

    def members(param)
      @action_metadata[:parameters][param].fetch(:members, [])
    end

    def format_members(param)
      out = []
      unless members(param).empty?
        out << indent_lines(8, '+ Members')
        members(param).each do |member|
          out << indent_lines(12, "+ `#{member}`")
        end
      end
      out
    end
  end
end
