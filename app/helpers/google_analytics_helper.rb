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
end
