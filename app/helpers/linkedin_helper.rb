module LinkedinHelper

  # bring linkendin mash in right format for chartkick
  def get_hash_for_time_and_attr(mash, attr)
    Hash[mash['all'].map do |v|
      [Time.at(v['time'] / 1000), v[attr]]
    end]
  end
end
