module FacebookHelper
  def convert_hash_to_single_elements_hash(elements, name)
    hash_of_name = {}
    elements.each { |key, value|
      next if value.nil?
      hash_of_name[key] = value[name]
    }
    return hash_of_name
  end

  def get_all_keys_of_hash_value(elements)
    value_keys = Set.new
    elements.each { |key, value|
      next if value.nil?
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

  def get_last_element_of_hash(element)
    values = element[element.keys.last]
  end

  def create_new_sorted_hash_for(element, name_to_sort)
    values = get_last_element_of_hash(element)
    new_hash = {}
    values.keys.each { |k|
      if k.include? name_to_sort
        new_hash[k[2..6]] = values[k]
      end
    }
    return new_hash.sort.to_h
  end

  def format_external_referrals(refs)
    all_sites = {}
    refs.each { |k, value|
      next if value.nil?
      value.each { |site, number|
        key = Addressable::URI.parse(site).host
        key = "no domain" if key.nil?
        if all_sites[key].nil?
          all_sites[key] = number
        else
          all_sites[key]+=number
        end
      }
    }
    return all_sites
  end
end
