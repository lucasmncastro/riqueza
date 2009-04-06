# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def number_to_currency(number, options = {})
    options[:unit] ||= "R$ "
    options[:separator] ||= ","
    options[:delimiter] ||= "."
    super number, options
  end
end
