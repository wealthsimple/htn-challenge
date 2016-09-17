require_relative 'return_calculator'

class YourReturnCalculator < ReturnCalculator
  def calculate!
    prev_snapshot_market_value = snapshots.first.market_value #taking the first snapshot's market value
    compounded_return = 1
    skipped_periods = 1

    for snapshot in snapshots[1..-1] #sublist of snapshots, excluding first snapshot, 
                                     #since we start calculating the difference from the second one

        if prev_snapshot_market_value == 0 
            #if we find the market_value is 0, we skip the day but track that the number of days between the two 
            #days for calculating the naive return so that we can take the root of it
            skipped_periods += 1
            next
        else
            #calculate daily naive_return
            naive_return_over_periods = ((snapshot.market_value - snapshot.cash_flow) / prev_snapshot_market_value)
            naive_return = naive_return_over_periods ** (1/skipped_periods) - 1 
            skipped_periods = 1
        end
        #multiply it to so-far calculated compounded_return
        compounded_return = compounded_return * (1 + naive_return)

        #set to be used for next loop
        prev_snapshot_market_value = snapshot.market_value
    end

    return compounded_return - 1
  end
end
