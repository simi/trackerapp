require 'csv'

class Entry::TsvProvider

  def initialize(attributes)
    @path = attributes[:path]
  end

  def all
    CSV.read(@path, { :col_sep => "|" }).map { |line|
      next if line.size < 2
      original_id = line[0]
      next if Entry.find_by_original_id(original_id).present?
      description = line[4]
      next if description.blank?
      minutes = line[3].to_i
      from = Time.parse(line[1])
      {
        username: name,
        date: from.to_date,
        original_minutes: minutes,
        minutes: minutes + 15 - (minutes % 15),
        original_id: original_id,
        description: description
      }
    }.compact
  end

end
