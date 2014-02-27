module ApplicationHelper

  def formatted_minutes(minutes, options = {})
    result = "#{minutes / 60}"
    result << " hours" if options[:legend]
    result << ":" if not options[:legend]
    result << " and " if options[:legend]
    result << "#{minutes % 60}"
    result << " minutes" if options[:legend]
    result
  end

end
