module TimeTrackingsHelper
  def sum_up_total_value_of_time_trackings(values)
    sum = 0
    values.each { |v|
      sum = sum + v.spent_time * v.hourly_rate
    }
    sum
  end

  def preset_value
    @time_tracking.date.strftime('%d/%m/%Y') unless @time_tracking.date.nil?
  end
end
