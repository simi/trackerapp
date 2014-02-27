class TimeParser

  def initialize(time_spent)
    @time_spent = time_spent
  end

  # 1:30, 1.5, 90, 1h, 270 m, 5, 200
  def minutes
    if @time_spent.include? ":"
      hours, minutes = @time_spent.split(":")
      hours.to_i * 60 + minutes.to_i
    elsif @time_spent.include? "."
      (@time_spent.to_f * 60).to_i
    elsif @time_spent.include? "h"
      mins = @time_spent.to_f * 60
      mins.to_i
    elsif @time_spent.include? "m"
      @time_spent.to_i
    elsif @time_spent.present? && @time_spent.to_i < 10
      @time_spent.to_i * 60
    else
      @time_spent.to_i
    end
  end

end
