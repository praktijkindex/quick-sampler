module Quick
  module Sampler
    #@!visibility private
    module DSL::CharacterClass
      class << self

        def expand *class_names
          class_names
            .map { |name| definitions[name] }
            .compact
            .flat_map { |definition|
              case definition
              when String
                definition.chars
              when Range
                definition.to_a
              when Array
                expand(*definition)
              end
            }.to_a
        end

        private

        def definitions
          {
            lower: "a".."z",
            upper: "A".."Z",
            alpha: [:lower, :upper],
            digits: "0".."9",
            alnum: [:alpha, :digits],
            punctuation: %q[~`!@#$%^&*()_-+={}|\\:;"'<,>.?/],
            whitespace: " \t\n",
            printable: [:alnum, :punctuation, :whitespace]
          }
        end

      end
    end
  end
end
