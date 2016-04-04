json.array!(@companies) do |company|
  json.extract! company, :id, :name, :description, :lead_source, :job_types, :website, :monthly_total, :predicting_value, :address, :lost
  json.url company_url(company, format: :json)
end
