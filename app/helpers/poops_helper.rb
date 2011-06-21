require 'digest'

module PoopsHelper
  def video(code)
    raw(sanitize code, :tags => %w{iframe}, :attributes => %w{src})
  end

  def poop_ids(category_id)
    Poop.ids_from_category(category_id)
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

  def salt(rjs = false)
    Digest::MD5.hexdigest "#{request.remote_ip}_#{rjs ? request.env['HTTP_REFERER'] : request.url}"
  end
end
