class Collection < Hash

  EXCESS_CARD_COUNT = 4

  def self.import filename
    cards = Collection.new
    
    File.open(filename).each_line do |line|
      name = line.split(" ")[1..-1].join(" ")
      count = line.split(' ')[0].to_i
      cards[name] = count unless name.match(/Forest|Plains|Mountain|Island|Swamp/)
    end
    
    cards
  end

  def excess
    excess = Collection.new
    self.each do |name, count| 
      if count > EXCESS_CARD_COUNT
        excess[name] = count - EXCESS_CARD_COUNT
      end
    end
    
    excess
  end

  def to_s
    str = ""
    self.each do |name, count|
      str << "#{count} #{name}\n"
    end

    str
  end

  def giveaways(other_collection)
    giveaways = Collection.new

    self.excess.each do |name, excess|
      other_count = other_collection[name] || 0
      if other_count < EXCESS_CARD_COUNT
        amount = [EXCESS_CARD_COUNT - other_count, excess].min
        giveaways[name] = amount
      end
    end

    giveaways
  end

end

coll1 = Collection::import(ARGV[0] || "own.coll")
if ARGV.size <= 1
  puts coll1.excess
else
  coll2 = Collection::import(ARGV[1])
  puts coll1.giveaways(coll2)
end
