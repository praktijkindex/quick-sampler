# Quick Sampler

Composable samplers of data: describe your randomness and watch it blend.

Quick Sampler is DSL for describing and sampling random data influenced by
Haskell/Erlang's QuickCheck generators by John Hughes et al, rantly gem by
Howard Yeh, theft gem by Shawn Anderson, Jessica Kerr's generatron gem, her
*Generative Testing for Better Code* talk and the rest of the cause-and-effect
chain all the way to big bang.

## Sampler vs Generator

**Sampler** is the same as **generator** in other randomness frameworks, but
tries to suggest an expanded understanding of what it can be used for.
Ordinarily one would *sample* a source of randomness, but one could just as
well *sample* some "real" data at random and pass it on, verbatim or randomly
transmuted. The term is supposed to suggest "the way of truth" view of
unchanging reality that Parmenides described in his *On Nature* in fifth
century BCE. To see what he meant back when Socrates was a young man - fix your
random seed and watch your "generators" repeat themselves. Smoke that,
Heraclitus.

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
But {https://github.com/jessitron/gerald#gerald will it blend?}

```irb
pry> sampler2 = Quick::Sampler.compile { config(upper_bound: 5).string(:lower) }
=> #<Enumerator::Lazy: #<Enumerator: #<Enumerator::Generator:0x007f295fd88058>:each>>
pry> sampler2.zip(sampler).first(5).to_h
=> {"bjm"=>-4027257104748747508,
 "bcrs"=>-540067903901761386,
 "wqfn"=>2107130696606126069,
 "disw"=>2495326937126240758,
 "rglv"=>2235767748081203791}```

Hell yeah, it blends.

### Compile

The aim of "compilation" is to avoid typing / save from reading the namespaces
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

### Sampler configuration

Some sampling parameters can be passed as arguments to a sampler function (like
character class `:lower` in the example above). Others - that affect multiple
sub-samplers in a definition - may be injected with a call to `config(...)` (like
`upper_bound` above).

(**Rosetta stone:** `upper_bound` is what in Haskell QuickCheck is known as `size`)

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
