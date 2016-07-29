# Cookbook testing

## Testing Prerequisites

A working ChefDK installation set as your system's default ruby. ChefDK can be downloaded at <https://downloads.chef.io/chef-dk/>

Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for integration testing.

## Installing dependencies

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

## Rakefile

```
$ chef exec rake -T
rake spec                     # Run ChefSpec examples
rake style                    # Run all style checks
rake style:chef               # Run Chef style checks
rake style:ruby               # Run Ruby style checks
rake style:ruby:auto_correct  # Auto-correct RuboCop offenses
rake test                     # Run all tests
```

## Style Testing

Ruby style tests can be performed by Rubocop by issuing either

```shell
chef exec rake style:ruby
```

Chef style/correctness tests can be performed with Foodcritic by issuing either

```shell
chef exec rake style:chef
```

## Spec Testing

Unit testing is done by running Rspec examples.

```
chef exec rake spec
```

## Integration Testing

To see a list of available test instances run:

```shell
chef exec kitchen list
```

To test specific instance run:

```shell
chef exec kitchen test INSTANCE_NAME
```

