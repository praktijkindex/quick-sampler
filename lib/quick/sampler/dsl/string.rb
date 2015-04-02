module Quick
  module Sampler
    class DSL
      def string *classes
        classes = [:printable] if classes.empty?
        repertoire = CharacterClass[*classes].to_a
        feed { repertoire.sample(rand(upper_bound)).join }
      end

      module CharacterClass
        class << self
          def [] *class_names
            class_names
              .select{|name| respond_to?(name)}
              .flat_map{|name| send(name).to_a}
          end

          def lower
            "a".."z"
          end

          def upper
            "A".."Z"
          end

          def alpha
            self[:lower, :upper]
          end

          def digits
            "0".."9"
          end

          def alnum
            self[:alpha, :digits]
          end

          def punctuation
            %q[~`!@#$%^&*()_-+={}|\\:;"'<,>.?/].chars
          end

          def whitespace
            " \t\n".chars
          end

          def printable
            self[:alnum,:punctuation,:whitespace]
          end
        end
      end
    end
  end
end
