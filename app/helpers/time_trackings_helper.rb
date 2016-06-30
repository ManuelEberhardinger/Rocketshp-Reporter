module TimeTrackingsHelper
  # get total time tracking value
  def sum_up_total_value_of_time_trackings(values)
    sum = 0
    values.each { |v|
      sum = sum + v.spent_time * v.hourly_rate
    }
    sum
  end

  # format value if there is a time
  # for use in datepicker
  def preset_value(time)
    time.strftime('%d/%m/%Y') unless time.nil?
  end
end
