module GoogleAnalyticsHelper
  def format_data_to_display(data)
    Hash[data.map do |item|
      [Date.parse(item[0]), item[1]]
    end]
  end

  def round_values(data)
    data.each { |key, value|
      data[key] = value[0..3]
    }
  end
end
