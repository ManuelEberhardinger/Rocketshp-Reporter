json.array!(@posts) do |post|
  json.extract! post, :id, :type, :start_time, :post
  json.url post_url(post, format: :json)
end
