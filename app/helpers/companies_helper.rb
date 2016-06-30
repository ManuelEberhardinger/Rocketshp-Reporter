module CompaniesHelper
  # sum up the total revenue of all companies
  def sum_up_monthly_total(values)
    sum = 0
    values.each { |v|
      sum = sum + v.monthly_total.to_i
    }
    sum
  end

  # sum up the one time cost of all companies
  def sum_up_one_time_cost(values)
    sum = 0
    values.each { |v|
      sum = sum + v.one_time_cost.to_i
    }
    sum
  end

  # calculate the total amount money used with the spent time
  def sum_up_total_value_of_time_trackings(values)
    sum = 0
    values.each { |v|
      sum = sum + v.spent_time * v.hourly_rate
    }
    sum
  end

  # format data to display it in a pie chart (hours of time trackings)
  def sum_up_total_hours_to_display(values, total)
    return {} if total.blank?
    hours = {}
    sum = 0

    values.each { |v|
      sum = sum + v.spent_time
    }
    left = total - sum
    left = 0 if left < 0

    # save it in hash for chartkick
    hours[:spent] = sum
    hours[:left] = left
    hours
  end

  # format data to display it in a pie chart (money)
  def get_total_values_to_display(values, total)
    return {} if total.blank?
    sum = sum_up_total_value_of_time_trackings(values)
    money = {}
    left = total - sum
    left = 0 if left < 0

    # save it in hash for chartkick
    money[:used] = sum
    money[:left] = left
    money
  end

  # sum up the time of every single employee to create a chart
  def get_spent_time_of_employees(values)
    return {} if values.nil?
    employees = Hash.new(0)
    values.each { |v|
      employees[v.user.name] = employees[v.user.name] + v.spent_time
    }
    employees
  end

  # check for which month the post report should be created
  def get_month_for_posts_report(start_date)
    if start_date.blank?
      "create_post_report.pdf"
    else
      "create_post_report.pdf?start_date=" + start_date.to_s
    end
  end

  # for creating header in the post pdf report. get name of month.
  def get_month(start_date)
    if start_date.blank?
      Date.today.strftime("%B")
    else
      start_date.strftime("%B")
    end
  end

  # get the headline of the dashboard, depends on the status
  def get_header(status)
    if status == "1"
      "Active Clients"
    elsif status == "2"
      "Pipeline"
    elsif status == "3"
      "Lost Clients"
    elsif status == "4"
      "Completed"
    else
      "Dashboard"
    end
  end

  # status collection for the collection_select tag
  def get_status_collection
    status_hash = [
      [1, 'Active'],
      [2, 'Pipeline'],
      [3, 'Lost'],
      [4, 'Completed']
    ]
  end

  # maps the status to the name
  def get_name_of_status(status)
    if status == 1 || status == "1"
      "Active"
    elsif status == 2 || status == "2"
      "Pipeline"
    elsif status == 3 || status == "3"
      "Lost"
    elsif status == 4 || status == "4"
      "Completed"
    else
      ""
    end
  end

  # get title of the income, different for each dashboard
  def get_name_of_income(status)
    if status == "2" || status == 2
      "Predicted "
    elsif status == "3" || status == 3
      "Lost "
    else
      "Monthly "
    end
  end

  # add a http protocol to the url if there is no protocol
  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end
