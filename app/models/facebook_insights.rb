class FacebookInsights
  def self.connect_with_mongodb
    @db = 'facebookdb'
    @client = Mongo::Client.new(['127.0.0.1:27017'], database: @db)
  end

  def self.close_connection
    @client.close
  end

  def self.fresh_up_data(name, insights)
    connect_with_mongodb if @client.nil?
    @client[name].drop
    @client[name].insert_many(insights)
  end

  def self.get_single_metric(name, metric)
    convert_to_display_hash(find_insight(name, metric))
  end

  def self.convert_to_display_hash(elements)
    Hash[elements.map do |item|
      [Date.parse(item['end_time']), item['value']]
    end]
  end

  def self.find_insight(name, metric)
    @client[name].find(name: metric).projection(values: 1, _id: 0).to_a[0]['values']
  end

  def self.collection_exists?(collection_name)
    connect_with_mongodb if @client.nil?
    0 != @client[collection_name].find().to_a.count
  end
end
