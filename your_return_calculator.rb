require_relative 'return_calculator'

class YourReturnCalculator < ReturnCalculator
  def calculate!
    # Write your code here.
    # You have access to the `snapshots` variable.
    #
    # You can access the following properties of a snapshot:
    # snapshot.date
    # snapshot.cash_flow
    # snapshot.market_value

    periods = []
    snapshots.each_with_index  do |snapshot, i|
        next if i == 0 # We need to start at the second day
        periods << naive_func(snapshot, snapshots[i-1])
    end

    return geom_link(periods)
  end

  def naive_func (current, previous)
      ((current.market_value - current.cash_flow) / previous.market_value) - 1.to_b
  end

  def geom_link (periods)
      periods.reduce(1.to_b) { |sum, n| sum * (1.to_b + n) } - 1.to_b
  end
end

class Integer
    def to_b
        BigDecimal.new(self)
    end
end
