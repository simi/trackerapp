class Entry < ActiveRecord::Base

  def formatted_minutes
    "#{self.minutes / 60}: #{self.minutes % 60}"
  end

  def self.all_original(settings)

    settings.users.map {|name, attrs|
      if attrs['tracker'] == 'freckle'
        connect_to_freckle(attrs)

        records = LetsFreckle::Entry.find
        records = records.select { |r| r.project_id == attrs['credentials']['project_id'].to_i }
        records.map { |record|
          existing  = Entry.find_by_original_id(record[:id])
          if existing.blank?
            Entry.new(user: name,
                      date: record[:date],
                      original_minutes: record[:minutes],
                      minutes: record[:minutes],
                      original_id: record[:id], 
                      description: record[:description])
          end
        }.compact
      elsif attrs['tracker'] == 'tsv'
        CSV.read(attrs['path'], { :col_sep => "|" }).map { |line|
          next if line.size < 2
          minutes = line[3].to_i
          from = Time.parse(line[1])
          original_id = line[0]
          existing  = Entry.find_by_original_id(original_id)
          if existing.present?
            existing.description = line[4]
            existing
          else
            Entry.new(user: name,
                      date: from.to_date,
                      original_minutes: minutes,
                      minutes: minutes + 15 - (minutes % 15),
                      original_id: original_id,
                      description: line[4])
          end
          
        }.compact
      end
    }.flatten
  end

  private

  def self.connect_to_freckle(attrs)
    LetsFreckle.configure do
      account_host attrs['credentials']['host']
      username attrs['credentials']['username']
      token attrs['credentials']['token']
    end
  end

end
