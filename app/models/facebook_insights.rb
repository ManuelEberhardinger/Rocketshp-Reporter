class FacebookInsights
  def self.connect_with_mongodb(db)
    close_connection
    @client = Mongo::Client.new(ENV['MONGOLAB_URI'])
  end

  def self.close_connection
    if(!@client.nil?)
      @client.close
    end
  end

  def self.fresh_up_data(name, insights)
    connect_with_mongodb if @client.nil?
    @client[name].drop
    @client[name].insert_many(insights)
  end

  def self.get_single_metric(name, metric)
    convert_to_display_hash(find_insight(name, metric))
  end

  def self.get_single_metric_with_period(name, metric, period)
    convert_to_display_hash(find_insight_with_period(name, metric, period))
  end

  def self.convert_to_display_hash(elements)
    Hash[elements.map do |item|
      [Date.parse(item['end_time']), item['value'] ||= 0]
    end]
  end

  def self.find_insight(name, metric)
    @client[name].find(name: metric).projection(values: 1, _id: 0).to_a[0]['values']
  end

  def self.find_all(name)
    @client[name].find().to_a
  end

  def self.find_insight_with_period(name, metric, period)
    @client[name].find({name: metric, period: period}).projection(values: 1, _id: 0).to_a[0]['values']
  end

  def self.collection_exists?(collection_name)
    connect_with_mongodb if @client.nil?
    0 != @client[collection_name].find().to_a.count
  end

  def self.destroy_collection(name)
    connect_with_mongodb if @client.nil?
    @client[name].drop
  end
end
