# Sidetrack

Don't want to be sidetracked by endless state logic maintenance - use Sidetrack.

Keeping track of changing states of models gets to be a drag. The simple
solution of a state field works in the simplest of cases but invariably you want
to know when the state change happened and maybe also who or what instigated the
change. Perhaps you even want a historical record of all state changes. Suddenly
your model and datatable are littered with something_at and something_by fields
some of which might never be used for many objects.

Recently it occurred to me that it would make sense to have a single table to
normalize these state changes. Moreover, by making it polymorphic the need to
be constantly adding new state fields evaporates. Extracting this idea to a gem
with a little meta-programming syntactical sugar and you get a gem with the
clever name of Sidetrack.

## Usage

Sidetrack requires a trackings table whose migration can be generated with

```bash
rails g sidetrack:install
```

If you also want to keep track of which object actors initiated the change then add
the `--track-actors` option. You will also need to add this configuration to an
initializer:

```ruby
Sidetrack.config.track_actors = true
```

Now you can simply add something like this to your ActiveRecord models:

```ruby
class Vegetable < ApplicationRecord
  sidetrack :planted, :weeded, :harvested
end
```

You now have access to these helpful methods:

```ruby
carrot = Vegetable.create(name: 'carrot')
carrot.planted! # defaults to Time.now but you can also set it with first arg
carrot.weeded!(Time.now.ago(1.week))

carrot.planted? # true
carrot.weeded_at # 1.week.ago
```

By default sidetrack will update one tracking record per event but you can
also add the track_history option to keep a more detailed history of changes

```ruby
class Fruit < ApplicationRecord
  sidetrack :picked, track_history: true
end

apple = Fruit.create(name: 'apple')

apple.picked!(Time.now.ago(1.week))
apple.picked!(Time.now.ago(1.day))

apple.picked_history # returns an ordered array of datetime
```

If you want to also keep track of who or what initiated the event use the
following:

```ruby
class Grain < ApplicationRecord
  sidetrack :sown, track_actors: true
end

wheat = Grain.create(name: 'wheat')
frank = Farmer.create(name: 'Frank')
wheat.sown!(actor: frank)

wheat.sown_by # returns frank
```

## Installation
Coming soon

## Contributing
Coming soon

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
