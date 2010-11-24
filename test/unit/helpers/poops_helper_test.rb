require 'test_helper'

class PoopsHelperTest < ActionView::TestCase
  fixtures :poops, :categories

  def setup
    @first = poops(:first)
    @second = poops(:second)
    @third = poops(:third)
    @last = poops(:last)
  end

  test 'it should return array of RYTPMV poops' do
    poops = poop_ids(@second.category_id)
    assert_equal poops.count, 2
    assert_equal poops, [ @first.id, @second.id ]
    
    nextp = next_poop(@second)
    assert_equal nextp, watch_path(@first.id)
    prevp = previous_poop(@second)
    assert_equal prevp, watch_path(@first.id)

    nextp = next_poop(@first)
    assert_equal nextp, watch_path(@second.id)
    prevp = previous_poop(@first)
    assert_equal prevp, watch_path(@second.id)

    poops = poop_ids(@last.category_id)
    assert_equal poops.count, 2
    assert_equal poops, [ @last.id, @third.id ]

    nextp = next_poop(@last)
    assert_equal nextp, watch_path(@third.id)
    prevp = previous_poop(@last)
    assert_equal prevp, watch_path(@third.id)

    nextp = next_poop(@third)
    assert_equal nextp, watch_path(@last.id)
    prevp = previous_poop(@third)
    assert_equal prevp, watch_path(@last.id)
  end
end
