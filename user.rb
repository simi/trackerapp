class User

  attr_accessor :name, :entries, :total

  def initialize(name, entries)
    @name = name
    @entries = entries
    @total = entries.sum(:minutes)
  end

end
