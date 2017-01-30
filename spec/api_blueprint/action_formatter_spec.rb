require 'spec_helper'

require 'json'

RSpec.describe ApiBlueprintFormatter::ActionFormatter do
  subject { described_class.new(action_name, action_metadata).format }

  let(:action_name) { 'Standard Action [GET /api/v0/resource]' }
  let(:action_metadata) { { description: action_description, parameters: action_parameters } }

  let(:action_description) { 'Lorem ipsum et dolor' }
  let(:action_parameters) { {} }

  describe '#format' do
    context 'with standard meta-data' do
      it 'formats properly' do
        is_expected.to eq "## Standard Action [GET /api/v0/resource]\n\nLorem ipsum et dolor\n\n"
      end
    end

    context 'with parameters' do
      let(:action_header) { "## #{action_name}\n\n#{action_description}\n" }

      context 'only descriptive params' do
        let(:action_parameters) do
          {
            id: { description: 'Id of a post' }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + id - Id of a post

          EOF
        end
      end

      context 'descriptive param with type' do
        let(:action_parameters) do
          {
            id: { description: 'Id of a post', type: :number }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + id (number) - Id of a post

          EOF
        end
      end

      context 'descriptive param with type and optionality' do
        let(:action_parameters) do
          {
            amount: { description: 'Id of a post', type: :number, optional: true }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + amount (number, optional) - Id of a post

          EOF
        end
      end

      context 'descriptive param with: type, optionality and example value' do
        let(:action_parameters) do
          {
            amount: { description: 'Id of a post', type: :number, optional: true, example: 123 }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + amount: 123 (number, optional) - Id of a post

          EOF
        end
      end

      context 'descriptive param with: type, optionality, default value' do
        let(:action_parameters) do
          {
            amount: { description: 'Id of a post', type: :number, optional: true, default: 0 }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + amount (number, optional) - Id of a post
        + Default: 0

          EOF
        end
      end

      context 'descriptive param with: enum and members' do
        let(:action_parameters) do
          {
            id: { description: 'Id of a post', type: 'enum[string]', members: %w(A B C) }
          }
        end

        it do
          is_expected.to eq <<-EOF
#{action_header}

+ Parameters
    + id (enum[string])

        Id of a post

        + Members
            + `A`
            + `B`
            + `C`

          EOF
        end
      end
    end
  end
end
