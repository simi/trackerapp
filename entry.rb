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
        records.map do |record|
          Entry.new(user: name,
                    date: record[:date],
                    original_minutes: record[:minutes],
                    minutes: record[:minutes],
                    original_id: record[:id], 
                    description: record[:description])
        end
      end
    }.flatten
  end

  def import?
    Entry.where(original_id: self.original_id).blank?
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
