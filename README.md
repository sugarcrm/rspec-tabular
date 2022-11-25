# Rspec::Tabular

[![Gem Version](https://badge.fury.io/rb/rspec-tabular.svg)](http://badge.fury.io/rb/rspec-tabular)
[![Build Status](https://github.com/sugarcrm/rspec-tabular/actions/workflows/ci.yml/badge.svg)](https://github.com/sugarcrm/rspec-tabular/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/sugarcrm/rspec-tabular/badges/gpa.svg)](https://codeclimate.com/github/sugarcrm/rspec-tabular)
[![Test Coverage](https://codeclimate.com/github/sugarcrm/rspec-tabular/badges/coverage.svg)](https://codeclimate.com/github/sugarcrm/rspec-tabular/coverage)
[![License](http://img.shields.io/badge/license-Apache2-green.svg?style=flat)](LICENSE)

[![Inline docs](http://inch-ci.org/github/sugarcrm/rspec-tabular.svg)](http://inch-ci.org/github/sugarcrm/rspec-tabular)
[![RubyDoc](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://rubydoc.org/gems/rspec-tabular)

Rspec extension for writing tabular examples

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-tabular'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-tabular

## Usage

Here is an overall example using the rspec, followed by some more details of
the specified scenarios:

The input values which are specified are exposed as *let* values, so they can
be used in both the subject inputs or in stub/double expectations specified in
a before block.

```
describe '#thing' do
  subject { subject.thing(input1, input2) }
  before ( stub_model(ThingyModel, name: input3) }

  let(:expected_value) { :expected_value }

  inputs            :input1,  :input2,  :input3
  it_with           'value1', 'value2', 'value3',  nil
  it_with           'value4', 'value5', 'value6',  true
  it_with           'value7', 'value8', 'value9',  'foobar'
  specify_with      'value1', 'value2', 'value3',  'foobar'
  it_with(          'value1', 'value2', 'value3' ) { is_expected.to eq(expected_value) }
  specify_with(     'value1', 'value2', 'value3' ) { expect(subject).to eq(expected_value) }

  its_with :method, 'value1', 'value2', 'value3',  'something'

  raise_error_with  'bad1',   'bad2',   'bad3',    'error'
  raise_error_with  'bad4',   'bad5',   'bad6',    TestException
  raise_error_with  'bad4',   'bad5',   'bad6',    TestException, 'error'

  side_effects_with 'value4', 'value5', 'value6'
```

*specify_with* is an alias to *it_with*, therefore they both have the same
behaviour.

Please remember inputs or expected result values MUST be literal values, and cannot be
values memoized with let, because the let values are not evaluated soon enough.
You can use let values in the expectations if they are specified in a block.
(e.g., { is_expected.to eq(expected_value) })


### Equivalencies

Each of the tabular statements has an equivlanet non-tabular example to which
is corresponds.

```
it_with           'value1', 'value2', 'value3', nil

# Equivalent to:
context do
  let(:input1) { 'value1' }
  let(:input2) { 'value2' }
  let(:input3) { 'value3' }

  it { expected.to be_nil }
end
```

```
it_with(          'value1', 'value2', 'value3' ) { is_expected.to eq(expected_value) }

# Equivalent to:
context do
  let(:input1) { 'value1' }
  let(:input2) { 'value2' }
  let(:input3) { 'value3' }

  it { is_expected.to eq('expected') } }
end
```

```
raise_error_with  'bad4',   'bad5',   'bad6',    TestException, 'error'

# Equivalent to:
context do
  let(:input1) { 'bad4' }
  let(:input2) { 'bad5' }
  let(:input3) { 'bad6' }

  specify { expect { subject }.to raise_error(TestException, 'error') }
end
```

```
side_effects_with 'value4', 'value5', 'value6'

# Equivalent to:
context do
  let(:input1) { 'value4' }
  let(:input2) { 'value5' }
  let(:input3) { 'value6' }

  specify { subject } }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Elsewhere on the web

Links to other places on the web where this projects exists:

* [Code Climate](https://codeclimate.com/github/sugarcrm/rspec-tabular)
* [CucumberPro](https://app.cucumber.pro/projects/rspec-tabular)
* [InchCI](http://inch-ci.org/github/sugarcrm/rspec-tabular)
* [Github](https://github.com/sugarcrm/rspec-tabular)
* [OpenHub](https://www.openhub.net/p/rspec-tabular)
* [RubyDoc](http://rubydoc.org/gems/rspec-tabular)
* [RubyGems](https://rubygems.org/gems/rspec-tabular)
* [Ruby LibHunt](https://ruby.libhunt.com/rspec-tabular-alternatives)
* [Ruby Toolbox](https://www.ruby-toolbox.com/projects/rspec-tabular)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for how you can contribute changes back into this project.

## License

Copyright 2019 [SugarCRM Inc.](http://sugarcrm.com), released under the Apache2 License.
