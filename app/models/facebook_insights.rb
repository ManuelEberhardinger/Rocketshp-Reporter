class FacebookInsights

  # close connection and connect to mongodb client
  def self.connect_with_mongodb
    close_connection
    @client = Mongo::Client.new(ENV['MONGOLAB_URI'])
  end

  # if there is a client, close connection
  def self.close_connection
    if(!@client.nil?)
      @client.close
    end
  end

  # update data (drop it first than insert again)
  def self.fresh_up_data(name, insights)
    connect_with_mongodb if @client.nil?
    @client[name].drop
    @client[name].insert_many(insights)
  end

  # get a metric from a collection name
  def self.get_single_metric(name, metric)
    convert_to_display_hash(find_insight(name, metric))
  end

  # get a metric for a given period
  def self.get_single_metric_with_period(name, metric, period)
    convert_to_display_hash(find_insight_with_period(name, metric, period))
  end

  # convert metric to ruby hash in the form chartkick needs it
  def self.convert_to_display_hash(elements)
    Hash[elements.map do |item|
      [Date.parse(item['end_time']), item['value'] ||= 0]
    end]
  end

  # query data from MongoDB database
  def self.find_insight(name, metric)
    @client[name].find(name: metric).projection(values: 1, _id: 0).to_a[0]['values']
  end

  # get all data from database
  def self.find_all(name)
    @client[name].find().to_a
  end

  # query data from MongoDB database with time period
  def self.find_insight_with_period(name, metric, period)
    @client[name].find({name: metric, period: period}).projection(values: 1, _id: 0).to_a[0]['values']
  end

  # check if collection exists
  def self.collection_exists?(collection_name)
    connect_with_mongodb if @client.nil?
    0 != @client[collection_name].find().to_a.count
  end

  # delete collection in database
  def self.destroy_collection(name)
    connect_with_mongodb if @client.nil?
    @client[name].drop
  end
end
