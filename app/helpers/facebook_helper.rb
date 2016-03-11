module FacebookHelper
  def convert_hash_to_single_elements_hash(elements, name)
    hash_of_name = {}
    elements.each { |key, value|
      hash_of_name[key] = value[name]
    }
    return hash_of_name
  end

  def get_all_keys_of_hash_value(elements)
    value_keys = Set.new
    elements.each { |key, value|
      value.each { |k, v|
        value_keys.add(k)
      }
    }
    return value_keys.to_a
  end

  def get_series_hash_for_chartkick(insight_hash)
    all_series = Array.new
    names = get_all_keys_of_hash_value(insight_hash)
    names.each { |value|
      series = convert_hash_to_single_elements_hash(insight_hash, value)
      all_series.push({name: value, data: series})
    }
    return all_series
  end

  def get_number_of_views(element)
    number_of_views = 0
    element.values.each { |v|
      number_of_views += v
    }
    return number_of_views
  end
end
