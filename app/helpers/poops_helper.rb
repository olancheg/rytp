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

  def poop_ids(category)
    @@poops ||= Poop.by_category(category).approved.map {|e| e.id}
  end

  def random_poop(category)
    poops = poop_ids(category)
    poops ? watch_path(poops.at rand(poops.count-1)) : root_path
  end

  def previous_poop(category, current)
    poops = poop_ids(category)
    poops ? watch_path(poops.at poops.index(current)||0-1) : root_path
  end

  def next_poop(category, current)
    poops = poop_ids(category)

    if poops
      pos = poops.index(current)
      watch_path poops.at(pos == (poops.count-1) ? 0 : pos+1)
    else
      root_path
    end
  end
end
