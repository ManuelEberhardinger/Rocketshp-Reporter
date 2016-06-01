module GoogleAnalyticsHelper
  # formate data to a hash with date => value
  def format_data_to_display(data)
    Hash[data.map do |item|
      [Date.parse(item[0]), item[1]]
    end]
  end

  # create hash grouped by the campaing pointing to other hash date => value, so you have a hash of hashes
  def format_campaign_and_date(data)
    Hash[data.group_by { |(campaign, _date, _value)| campaign }.map do |key, value|
           [key,
            Hash[value.map do |item|
                   [Date.parse(item[1]), item[2]]
                 end]]
         end]
  end

  # format campaings for the 4 selected metrics clicks, cost, cpc, ctr
  def format_campaigns(data)
    Hash[data.map do |item|
      [item[0], Hash[
          'clicks', item[1],
          'cost', item[2],
          'cpc', item[3],
          'ctr', item[4]
        ]
      ]
    end]
  end

  # get increase or decrease in percent for adwords of the last month
  def get_change(this_month, prev_month)
    this_month = this_month.to_f
    prev_month = prev_month.to_f
    change = ((this_month - prev_month) / prev_month) * 100
    if change > 0
      '+%.2f%' % change
    else
      '%.2f%' % change
    end
  end

  # round values to 2 digits after point
  def round_values(data)
    data.each do |key, value|
      data[key] = '%.2f' % value
    end
  end

  # chartkick options for pie chart
  def show_pie_chart_value
    options = { plotOptions: { pie: { dataLabels: { enabled: true, format: '<b>{key}</b>: {point.y}' } } } }
  end

  # change color of label if text value is positive to green otherwise tor red
  def change_color(text)
    if text.include? "+"
      '<span class="label label-success">' + text + '</span>'
    elsif text.include? "-"
      '<span class="label label-danger">' + text + '</span>'
    end
  end

  # change color if text is minus to green otherwise to red
  def change_color_reverse(text)
    if text.include? "-"
      '<span class="label label-success">' + text + '</span>'
    elsif text.include? "+"
      '<span class="label label-danger">' + text + '</span>'
    end
  end

  def fill_select_for_accounts(profiles)
    select_list = []

    profiles.each { |profile|
      profile[:web_properties].each { |views|
        views[:profiles].each { |view|
          select_list.push([(views[:name] + " - " + view[:name]), view[:id]])
        }
      }
    }
    return select_list
  end
end
