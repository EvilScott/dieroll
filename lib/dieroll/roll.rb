module Dieroll
  class Roll
    def self.d(sides)
      rand(1..sides)
    end

    def self.string(string)
      num, sides = string.match(/^(\d+)d(\d+)/).captures
      num = num.to_i
      sides = sides.to_i

      total = 0
      num.times do
        total += Roll.d(sides)
      end
      return total
    end
  end
end
