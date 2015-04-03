require "set"
using Quick::Sampler::Shrink::Refinements

module Quick
  module Sampler
    module Shrink
      module ClassMethods
        module While
          def while values, &block
            shrunk = Set.new
            input_size = values.count
            values = values.reduce(Set.new) { |shrinking, current|
              report "shrunk: #{shrunk.count}, still shrinking: #{shrinking.count}"
              shrunk_current = (current.shrink||[])
                .reject{|candidate| candidate  == current}
                .select(&block)
              shrunk << current if shrunk_current.empty?
              shrinking + shrunk_current
            } until values.empty?
            report ""
            shrunk.to_a
          end

          def report message
            width = 80
            message = "" if message == :clear
            message = message[0...width]
            padding = " " * [width - message.length, 0].max
            print "#{message}#{padding}\r"
          end

        end
      end
    end
  end
end
