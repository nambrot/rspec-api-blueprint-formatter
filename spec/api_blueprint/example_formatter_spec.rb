require 'spec_helper'

require 'json'

RSpec.describe ApiBlueprintFormatter::ExampleFormatter do
  subject { described_class.new(example_description, example_metadata).format }

  let(:example_description) { "Standard Request" }
  let(:example_metadata) do
    {
        request: request_metadata,
        response: response_metadata,
        location: location,
        source: source
    }
  end

  let(:request_metadata) { { parameters: {}, format: 'application/json' } }
  let(:response_metadata) { { status: 200, body: JSON.generate({a:1, b:2, c:3}) } }
  let(:location) { "spec/api_blueprint/example_formatter_spec.rb" }
  let(:source) { "it 'returns standard APi Blueprint format' do\n  ;\nend" }


  describe '#format' do
    context 'with standard meta-data' do
      it 'formats properly' do
        is_expected.to eq <<EOF
+ Request Standard Request

        {}

        Location: spec/api_blueprint/example_formatter_spec.rb
        Source code:

        it 'returns standard APi Blueprint format' do
          ;
        end

+ Response 200 (application/json)

        {"a":1,"b":2,"c":3}

EOF
      end

      context 'and with parameters' do
        context 'from request data' do
          let(:request_metadata) { { parameters: {'p1': 'v1', 'p2': 'v2'}, format: 'application/json' } }

          it 'formats properly' do
            is_expected.to eq <<EOF
+ Request Standard Request

        {:p1=>"v1", :p2=>"v2"}

        Location: spec/api_blueprint/example_formatter_spec.rb
        Source code:

        it 'returns standard APi Blueprint format' do
          ;
        end

+ Response 200 (application/json)

        {"a":1,"b":2,"c":3}

EOF
          end

        end
      end
    end
  end

  describe '#example_description' do
    subject { described_class.new(example_description, example_metadata).example_description }

    context 'when description has non-compliant characters' do
      let(:example_description) { 'Standard Request for [company]' }

      it 'changes [] to {}' do
        expect(subject).to eq 'Standard Request for {company}'
      end
    end
  end

end