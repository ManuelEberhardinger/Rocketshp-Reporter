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

  def sum_up_total_hours_to_display(values, total)
    return {} if total.blank?
    hours = {}
    sum = 0
    values.each { |v|
      sum = sum + v.spent_time
    }
    left = total - sum
    left = 0 if left < 0
    hours[:spent] = sum
    hours[:left] = left
    hours
  end

  def get_total_values_to_display(values, total)
    return {} if total.blank?
    sum = sum_up_total_value_of_time_trackings(values)
    money = {}
    left = total - sum
    left = 0 if left < 0
    money[:used] = sum
    money[:left] = left
    money
  end

  def get_spent_time_of_employees(values)
    return {} if values.nil?
    employees = Hash.new(0)
    values.each { |v|
      employees[v.user.name] = employees[v.user.name] + v.spent_time
    }
    employees
  end

  def get_month_for_posts_report(start_date)
    if start_date.blank?
      "create_post_report.pdf"
    else
      "create_post_report.pdf?start_date=" + start_date.to_s
    end
  end

  def get_month(start_date)
    if start_date.blank?
      Date.today.strftime("%B")
    else
      start_date.strftime("%B")
    end
  end
end
