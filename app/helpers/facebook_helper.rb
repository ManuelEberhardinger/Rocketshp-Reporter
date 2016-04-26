module FacebookHelper
  # transform hash from key => {v_key => value, ...} into key => value (value is selected by name)
  def convert_hash_to_single_elements_hash(elements, name)
    hash_of_name = {}
    elements.each { |key, value|
      next if value.nil? || value == 0
      hash_of_name[key] = value[name]
    }
    return hash_of_name
  end

  # get all keys of the first hash in set so there are no duplicates
  def get_all_keys_of_hash_value(elements)
    value_keys = Set.new
    elements.each { |key, value|
      next if value.nil? || value == 0
      value.each { |k, v|
        value_keys.add(k)
      }
    }
    return value_keys.to_a
  end

  # group hash to the different key types in an array so chartkick can display it
  def get_series_hash_for_chartkick(insight_hash)
    all_series = Array.new
    names = get_all_keys_of_hash_value(insight_hash)
    names.each { |value|
      series = convert_hash_to_single_elements_hash(insight_hash, value)
      all_series.push({name: value, data: series})
    }
    return all_series
  end

  # sum up all values to get total number e.g. for video views hash
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

  # get last element of hash and sort it reverse order
  def get_last_element_sorted_by_value(element)
    Hash[get_last_element_of_hash(element).sort_by{|k, v| v}.reverse]
  end

  # sort hash reverse order by value
  def sort_by_value(element)
    Hash[element.sort_by{|k, v| v}.reverse]
  end

  # return single post for the given id
  def find_by_id(posts, id)
    posts.each { |value|
      return value if value['id'] == id
    }
  end

  # create a new hash for the values that include name_to_sort
  def create_new_sorted_hash_for(element, name_to_sort)
    values = get_last_element_of_hash(element)
    return if values.nil?
    new_hash = {}
    values.keys.each { |k|
      if k.include? name_to_sort
        new_hash[k[2..6]] = values[k]
      end
    }
    return new_hash.sort.to_h
  end

  # group all external referrals to the host site and count the number
  def format_external_referrals(refs)
    all_sites = {}
    refs.each { |k, value|
      next if value.nil? || value == 0
      value.each { |site, number|
        key = Addressable::URI.parse(site).host
        key = "unknown domain" if key.nil?
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
