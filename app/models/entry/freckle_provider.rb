class Entry::FreckleProvider

  attr_accessor :credentials, :project_id

  def initialize(attributes)
    @project_id = attributes.delete(:project_id).to_i

    @credentials = attributes

    LetsFreckle.configure do
      account_host attributes[:host]
      username attributes[:username]
      token attributes[:token]
    end
  end

  def all
    records = LetsFreckle::Entry.find
    records = records.select { |r| r.project_id == @project_id.to_i }
    records.map { |record|
      next if Entry.find_by_original_id(record[:id]).present?
      next if record[:description].blank?
      {
        date: record[:date],
        original_minutes: record[:minutes],
        minutes: record[:minutes],
        original_id: record[:id],
        description: record[:description]
      }
    }.compact
  end

end
