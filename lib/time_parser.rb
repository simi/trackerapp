class TimeParser
  def initialize(time_spent)
    @time_spent = time_spent
  end

  def minutes
  # 1:30, 1.5, 90, 1h, 270 minut
    if @time_spent.include? ":"
      hours, mins = @time_spent.split(":")
      @minutes = hours.to_i * 60 + mins.to_i
    elsif @time_spent.include? "."
      mins = @time_spent.to_f * 60
      @minutes = mins.to_i
    elsif @time_spent.include? "h"
      mins = @time_spent.to_f * 60
      @minutes = mins.to_i
    elsif @time_spent.include? "minut"
      @minutes = @time_spent.to_i
    else
      @minutes = @time_spent.to_i rescue @minutes = nil
    end
  end
end
