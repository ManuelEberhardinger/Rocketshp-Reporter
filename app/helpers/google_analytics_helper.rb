module GoogleAnalyticsHelper
  def format_data_to_display(data)
    Hash[data.map do |item|
      [Date.parse(item[0]), item[1]]
    end]
  end

  def round_values(data)
    data.each { |key, value|
      data[key] = '%.2f' % value
    }
  end

  def show_pie_chart_value
    options = { plotOptions: { pie: { dataLabels: { enabled: true, format: '<b>{key}</b>: {point.y}', } } }, }
  end
end
