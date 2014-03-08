class EntryForm < Form

  attr_accessor :time_spent, :project_id, :date, :description, :links, :user_id, :minutes

  validates :time_spent, presence: true
  validates :date, presence: true
  validates :minutes, presence: true

  def initialize(attributes = {})
    return if attributes.blank?

    @date = Date.parse(attributes.delete(:date))
    store(attributes)
    @minutes = TimeParser.new(attributes.delete(:time_spent)).minutes rescue nil
    @entry = Entry.new(attributes)
    @entry.minutes = @minutes
    @entry.date = @date
  end

  def submit
    valid? && @entry.save
  end

  def date_in_words
    # if date was set to today, or wasnt set at all
    if (@date.present? && @date == Date.current) || @date.blank?
      I18n.t('today_change').html_safe
    else
      I18n.l(@date, :format => "d% %B, %Y")
    end
  end

end
