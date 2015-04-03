module Quick
  module Sampler
    module Shrink
      module Refinements

        refine ::Object do
          def shrink
          end
        end

        refine ::Integer do
          def shrink
            # -1, 0 and 1 can't be shrunken
            if self > 10
              [self/2]
            elsif self > 1
              [self - 1]
            elsif self < -1
              [-self.abs.shrink.first]
            end
          end
        end

        refine ::String do
          def shrink
            if length > 1
              remove_indices = (0...length).to_a
              remove_indices = remove_indices.sample(1) if length > 9
              remove_indices.map{|i| remove_by_index(i)}
            end
          end

          def remove_by_index index
            dup.tap{|copy| copy.slice!(index)}
          end
        end

      end
    end
  end
end
