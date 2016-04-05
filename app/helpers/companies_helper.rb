module CompaniesHelper
  def sum_up_monthly_total(values)
    sum = 0
    values.each { |v|
      sum = sum + v.monthly_total.to_i
    }
    sum
  end
end
