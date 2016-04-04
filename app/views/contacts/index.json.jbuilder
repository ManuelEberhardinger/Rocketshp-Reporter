json.array!(@contacts) do |contact|
  json.extract! contact, :id, :company_id, :first_name, :last_name, :phone, :mobile, :email
  json.url contact_url(contact, format: :json)
end
