module PoopsHelper
  def video(code)
    raw(sanitize code, :tags => %w{iframe})
  end

  def voted?(poop)
    controller.voted?(poop)
  end
  
  def voted_bad?(poop)
    controller.voted_bad?(poop)
  end

  def random_poop(category)
    @@poops ||= Poop.by_category(category).approved.map(&:id)
    watch_path @@poops[rand(@@poops.count)]
  end

  def previous_poop(category, current)
    @@poops ||= Poop.by_category(category).approved.map(&:id)
    watch_path @@poops[@@poops.index(current)-1]
  end

  def next_poop(category, current)
    @@poops ||= Poop.by_category(category).approved.map(&:id)
    pos = @@poops.index(current)
    watch_path @@poops[pos == @@poops.count-1 ? 0 : pos+1]
  end
end
