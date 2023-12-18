module ApplicationHelper
  def format_indian_currency(number)
    if number.present?
      string = number.to_s.split('.')
      number = string[0].gsub(/(\d+)(\d{3})$/){ p = $2; "#{$1.reverse.gsub(/(\d{2})/,'\1,').reverse},#{p}" }
      if string[1]
        number = number.gsub(/^,/, '') + '.' + string[1]
      else
        number = number.gsub(/^,/, '') + '.00'
      end
      number = number[1..-1] if number[0] == 44
    end
    "Rs.#{number}"
  end
end
