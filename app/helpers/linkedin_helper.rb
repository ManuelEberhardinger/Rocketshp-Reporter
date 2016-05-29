module LinkedinHelper

  def get_hash_for_time_and_attr(mash, attr)
    Hash[mash['all'].map do |v|
      [Time.at(v['time'] / 1000), v[attr]]
    end]
  end
end
