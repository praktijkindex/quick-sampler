# Quick Sampler

Composable samplers of data: describe your randomness and watch it blend.

[![Gem Version](https://badge.fury.io/rb/quick-sampler.svg)](http://badge.fury.io/rb/quick-sampler)
[![Build Status](https://travis-ci.org/praktijkindex/quick-sampler.svg?branch=master)](https://travis-ci.org/praktijkindex/quick-sampler)

Quick Sampler is DSL for describing and sampling random data influenced by
Haskell/Erlang's [QuickCheck][1] generators by Koen Claessen and John Hughes, 
[rantly][2] gem by Howard Yeh, [theft][3] gem by Shawn Anderson, Jessica Kerr's 
[generatron][4] gem, her [Property-Based Testing for Better Code talk][5] and 
the rest of the cause-and-effect chain [all the way][6] to [big bang][7].

[1]: http://www.cse.chalmers.se/~rjmh/QuickCheck/
[2]: https://github.com/hayeah/rantly
[3]: https://github.com/shawn42/theft
[4]: https://github.com/jessitron/generatron/
[5]: http://www.windycityrails.org/videos/2014/#14
[6]: http://en.wikipedia.org/wiki/Turtles_all_the_way_down
[7]: http://en.wikipedia.org/wiki/Unmoved_mover

## Sampler vs Generator

**Sampler** is the same as **generator** in other randomness frameworks, but
tries to suggest an expanded understanding of what it can be used for.
Ordinarily one would *sample* a source of randomness, but one could just as
well *sample* some "real" data at random and pass it on, verbatim or randomly
transmuted. 

The term is supposed to suggest "the way of truth" view of
unchanging reality that Parmenides described in his *On Nature* in fifth
century BCE. To see what he meant back when Socrates was a young man - fix your
random seed and watch your "generators" repeat themselves. Smoke that,
Heraclitus.

<img src="https://cloud.githubusercontent.com/assets/64227/6993106/512cc778-daea-11e4-82dc-01cc8ef958fa.jpg"  height="200px">

## Usage

The main entry point is {Quick::Sampler.compile}. The method takes sampler
definition as block and returns a "compiled" sampler:

```
pry> sampler = Quick::Sampler.compile { integer }
=> #<Enumerator::Lazy: #<Enumerator: #<Enumerator::Generator:0x007f295f9b2af0>:each>>
pry> sampler.first(5)
=> [1763573971376409386, -1692192782152475313, -3665498119514965288, 0, 0]
```

So, the truth is out: a sampler is a lazy enumerator (and by extension - Enumerable).
But [will it blend?][8]

[8]: https://github.com/jessitron/gerald#gerald

```irb
pry> sampler2 = Quick::Sampler.compile { string(:lower, size: 3..5) }
=> #<Enumerator::Lazy: #<Enumerator: #<Enumerator::Generator:0x007f295fd88058>:each>>
pry> sampler2.zip(sampler).first(5).to_h
=> {"bjm"=>-4027257104748747508,
 "bcrs"=>-540067903901761386,
 "wqfn"=>2107130696606126069,
 "disw"=>2495326937126240758,
 "rglv"=>2235767748081203791}
```

Hell yeah, it blends.

### Compile

The aim of "compilation" is to deliver us from typing / reading the namespaces
in sampler definitions. Consider, for example:

```ruby
Quick::Sampler.compile do
  one_of_weighted integer => 10,
                  boolean => 1,
                  vector_of(5, integer) => 5
end
```

(**Rosetta stone:** `one_of_weighted` is what in Haskell QuickCheck is known as `frequency`)

vs hypothetic alternative:

```ruby
Generators.one_of_weighted Generators.integer => 10,
                           Generators.boolean => 1,
                           Generators.vector_of(5, Generators.integer) => 5
```

### Sampler composability

The composition using Enumerable API as demonstrated above is pretty flexible and familiar to a
ruby developer.

Some less "linear" shapes of data on the other hand are better
expressed by the Quick Sampler DSL within the sampler definition:

**TODO** replace with a real life example of a complex sampler.

```ruby
cities_sampler = Quick::Sampler.compile do
  send_to City, :build, name: string(:lower),
    state: pick_from(State.all),
    population: pick_from(1_000..10_000_000)
end

cities = cities_sampler.first(100)
cities.each &:save!

travellers_sampler = Quick::Sampler.compile do
  send_to Person, :build,
    name: string(:lower),
    born_in: pick_from(cities),
    lives_in: pick_from(cities),
    visited: list_of(pick_from(cities))
end

travellers = travellers_sampler.first(1000)
travellers.each &:save!
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quick-sampler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quick-sampler

## Contributing

1. Fork it ( https://github.com/praktijkindex/quick-sampler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
