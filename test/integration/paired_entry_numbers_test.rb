# frozen_string_literal: true

require "test_helper"

# Numbering is per language, so a post and its translation share a number only
# because every post here has a counterpart. The fixture site has unpaired
# posts and cannot check this; the real site can.
class PairedEntryNumbersTest < Minitest::Test
  def setup
    @site = TestHelper.build_real_site
  end

  def test_paired_posts_share_a_number
    @site.posts.docs.group_by { |doc| doc.data["ref"] }.each do |ref, pair|
      numbers = pair.map { |doc| doc.data["num"] }

      assert_equal 1, numbers.uniq.length, "#{ref} is numbered #{numbers.join(" and ")}"
    end
  end
end
