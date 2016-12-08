# RSpec APIBlueprint Formatter

Auto-generate API docs from your RSpec tests!

Turn something like

````ruby
it 'retrievs the patients medications' do
  retrieve_medications
  expect(JSON.parse(response.body).length).to eql 1
  expect(response).to have_http_status(:ok)
end
````

with simple annotations to your Rspec tests into:

![image](https://cloud.githubusercontent.com/assets/571810/11172057/0560c5b2-8bcd-11e5-9339-97dc11656fe2.png)

See the full demo [here](http://htmlpreview.github.io/?https://raw.githubusercontent.com/nambrot/blueprint-formatter-example-app/master/spec/apispec.html) from the [example app with RSpec tests](https://github.com/nambrot/blueprint-formatter-example-app)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-api-blueprint-formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-api-blueprint-formatter

## Usage

### Basic

RSpec APIBlueprint Formatter not surprisingly generates output that conforms to the [APIBlueprint spec](https://apiblueprint.org/). RSpec APIBlueprint Formatter makes some simplifying assumption and obviously falls short of manually crafted API docs. However, this can be a very efficient way to give your API consumers an easy to browse reference with basically 0 costs.

Effectively what the RSpec APIBlueprint Formatter will do is render tests you tag with `:apidoc` with their request parameters and response body and status. You will need to also tag your tests with (usually in parent context/describe blocks):

````
resource_group: 'Resource Group Name',
resource: 'Resource Name [/path/to/resouce]',
action: 'Retrieve list of resource [HTTP_VERB]'
action_description: 'Some accurate, verbose description of the action'
action_parameters: {parameter: { options: {} } }
````

There are some additional restrictions:

1. the `/path/to/resource` has to be unique across resources
2. the `HTTP_VERB` has to be unique within a resource

You use the formatter by specifying the `-f` flag `rspec spec -f ApiBlueprint` and it should print out the tests result in the APIBlueprint format. You can then use a renderer such as [Aglio](https://github.com/danielgtaylor/aglio) to turn the APIBlueprint format into a browsable HTML representation. It is recommended to create a rake task a la:

````ruby
task generate_api_docs: :environment do
  `rspec spec --tag apidoc -f ApiBlueprint --out spec/apispec.md`
  `aglio -i spec/apispec.md -o spec/apispec.html`
end
````

### Parameters

By default, the Request parameters are printed out as the given parameters in the specs. You can add more information about them by using the `action_parameters` metadata. The formatter supports most of the options for the [API Blueprint URL parameters](https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md#uri-parameters-section). A few examples below:

#### Standard parameter with description

Spec - general:

```ruby
let (:action_parameters) do
  {
    id: {description: 'Id of a post'}
  }
end

RSpec.describe 'POST /do_something', action_parameters: action_parameters, resource_group: 'Resources', resource: 'Resource', action: 'Do something', action_description: 'Do something' do

end
```

Generates:

```apib
+ Parameters
    + id - Id of a post.
```

#### Parameter with description and type

Spec:

```ruby
let (:action_parameters) do
  {
    id: {description: 'Id of a post', type: :number}
  }
end
```

Generates:

```apib
+ Parameters
    + id (number) - Id of a post.
```

#### Parameter with description, type and optional flag

Spec:

```ruby
let (:action_parameters) do
  {
    id: {description: 'Id of a post', type: :number, optional: true}
  }
end
```

Generates:

```apib
+ Parameters
    + id: `1001` (number, optional) - Id of a post.
```

#### Parameter with description, type and optional flag with default value

Spec:

```ruby
let (:action_parameters) do
  {
    id: {description: 'Id of a post', type: :number, optional: true, default: 20}
  }
end
```

Generates:

```apib
+ Parameters
    + id: `1001` (number, optional) - Id of a post.
        + Default: `20`
```

#### Enum parameter with description

Spec:

```ruby
let (:action_parameters) do
  {
    id: {description: 'Id of a post', type: 'enum[string]', members: %w(A B C)}
  }
end
```

Generates:

```apib
+ Parameters
    + id (enum[string])

        Id of a Post

        + Members
            + `A`
            + `B`
            + `C`
```

#### Other notes

- `<example value>` is not supported because it doesn't make sense with RSpec generated response bodies (already some example values there).
- `required` flag is not supported - it is the default anyway.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nambrot/rspec-api-blueprint-formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
