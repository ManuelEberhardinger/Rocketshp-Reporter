module GoogleAnalyticsHelper
  def format_data_to_display(data)
    Hash[data.map do |item|
      [Date.parse(item[0]), item[1]]
    end]
  end

  def format_campaign_and_date(data)
    Hash[data.group_by { |(campaign, _date, _value)| campaign }.map do |key, value|
           [key,
            Hash[value.map do |item|
                   [Date.parse(item[1]), item[2]]
                 end]]
         end]
  end

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

  def round_values(data)
    data.each do |key, value|
      data[key] = '%.2f' % value
    end
  end

  def show_pie_chart_value
    options = { plotOptions: { pie: { dataLabels: { enabled: true, format: '<b>{key}</b>: {point.y}' } } } }
  end

  def geo_map_options
    options = { colorAxis: { colors: ['#e6ffe6', 'green'] }, legend: { textStyle: { fontSize: 10 } } }
  end

  def change_color(text)
    if text.include? "+"
      '<span class="label label-success">' + text + '</span>'
    elsif text.include? "-"
      '<span class="label label-danger">' + text + '</span>'
    end
  end

  def change_color_reverse(text)
    if text.include? "-"
      '<span class="label label-success">' + text + '</span>'
    elsif text.include? "+"
      '<span class="label label-danger">' + text + '</span>'
    end
  end
end
