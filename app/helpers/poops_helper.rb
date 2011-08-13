module PoopsHelper
  def video(code)
    raw(sanitize code, :tags => %w{iframe}, :attributes => %w{src})
  end

  def random_poop(poop)
    poops = poops_from_category(poop.category_id)
    poops ? poops.at(rand(poops.count - 1)) : last_poop
  end

  def previous_poop(poop)
    poops = poops_from_category(poop.category_id)
    poops ? poops.at((poops.index(poop.id) || 0) - 1) : last_poop
  end

  def next_poop(poop)
    poops = poops_from_category(poop.category_id)
    pos = poops.index(poop.id) || 0
    poops ? poops.at(pos == (poops.count - 1) ? 0 : pos + 1) : last_poop
  end
end
