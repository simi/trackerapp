class User

  attr_accessor :name, :records, :total

  def initialize(name, records)
    @name = name
    @records = records
    @total = records.inject(0) { |sum, record| sum += record[:minutes].to_i; sum }
  end

  def self.connect_to_freckle(attrs)
    LetsFreckle.configure do
      account_host attrs['credentials']['host']
      username attrs['credentials']['username']
      token attrs['credentials']['token']
    end
  end

  def self.find_all_from(from, settings)
    @users = settings.users.map do |name, attrs|
      connect_to_freckle(attrs) if attrs['tracker'] == 'freckle'

      records = LetsFreckle::Entry.find(:from => from.to_s)
      records = records.select { |r| r.project_id == attrs['credentials']['project_id'].to_i }
      User.new(name, records)
    end
  end

end
