module Helpers
  def format_author(author)
    parts = []
    parts << author[:name] if author[:name]
    parts << "<a href=\"mailto:#{author[:email]}\">#{author[:email]}</a>" if author[:email]
    if author[:website] and author[:company]
      parts << "<a href=\"#{author[:website]}\">#{author[:company]}</a>"
    elsif author[:company]
      parts << author[:company]
    end
    parts.join(', ')
  end
  
  def format_header(header)
    "#{header[0,1].upcase}#{header[1..-1].downcase}"
  end
  
  def pluralize(cardinality, singular, plural)
    [cardinality, cardinality == 1 ? singular : plural].join(' ')
  end
  
  def format_estimate(cardinality, interval)
    case interval
    when :days
      pluralize(cardinality, 'day', 'days')
    when :weeks
      pluralize(cardinality, 'week', 'days')
    else
      cardinality.to_s
    end
  end
end