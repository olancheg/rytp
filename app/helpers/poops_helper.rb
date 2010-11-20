module PoopsHelper
  def video(code)
    raw(sanitize code, :tags => %w{iframe})
  end

  def voted?(poop)
    controller.voted?(poop)
  end
end
