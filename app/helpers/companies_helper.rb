module CompaniesHelper
  def sum_up_monthly_total(values)
    sum = 0
    values.each { |v|
      sum = sum + v.monthly_total.to_i
    }
    sum
  end

  def sum_up_total_value_of_time_trackings(values)
    sum = 0
    values.each { |v|
      sum = sum + v.spent_time * v.hourly_rate
    }
    sum
  end
end
