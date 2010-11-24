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
    Poop.approved.find_all_by_category_id(category).map(&:id)
  end

  def random_poop(poop)
    poops = poop_ids(poop.category_id)
    poops ? watch_path(poops.at rand(poops.count-1)) : root_path
  end

  def previous_poop(poop)
    poops = poop_ids(poop.category_id)
    poops ? watch_path(poops.at((poops.index(poop.id)||0)-1)) : root_path
  end

  def next_poop(poop)
    poops = poop_ids(poop.category_id)

    if poops
      pos = poops.index(poop.id)||0
      watch_path poops.at(pos == (poops.count-1) ? 0 : pos+1)
    else
      root_path
    end
  end
end
