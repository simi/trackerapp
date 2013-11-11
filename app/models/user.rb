class User
  attr_accessor :name, :entries, :total

  def initialize(name, entries)
    @name = name
    @entries = entries
    @total = entries.sum(:minutes)
    puts @name
    puts @total
  end
end
