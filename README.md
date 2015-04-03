# Quick Sampler

Composable samplers of data. Describe randomness and watch it blend.

Quick Sampler is DSL for describing and sampling random data influenced by
Haskell/Erlang's QuickCheck generators by John Hughes et al, rantly gem by
Howard Yeh, theft gem by Shawn Anderson, Jessica Kerr's generatron gem and
*Generative Testing for Better Code* talk and the rest of the cause-and-effect
chain all the way to big bang.

## Sampler vs Generator

**Sampler** is the same as **generator** in other randomness frameworks, but
tries to suggest an expanded understanding of what it can be used for.
Ordinarily one would *sample* a source of randomness, but one could just as
well *sample* some "real" data at random and pass it on, verbatim or randomly
transformed. The term is supposed to suggest "the way of truth" view of
unchanging reality as described by Parmenides in *On Nature* in fifth century
BCE. To see what he meant back when Socrates was a young man - fix your random
seed and watch your "generators" repeat themselves.

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
