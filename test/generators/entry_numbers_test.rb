# frozen_string_literal: true

require "test_helper"

# Entry numbers are per-language and reverse-chronological: the newest entry
# is 001, matching the reference design. They are display metadata only.
class EntryNumbersTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_newest_english_post_is_001
    assert_equal "001", post_at("/writing/alpha/").data["num"]
  end

  def test_older_english_post_is_002
    assert_equal "002", post_at("/writing/beta/").data["num"]
  end

  def test_numbering_restarts_per_language
    # The single PT post is the newest PT post, so it is also 001 — it is not
    # numbered 003 off the back of the English sequence.
    assert_equal "001", post_at("/pt/writing/alpha/").data["num"]
  end

  def test_paired_posts_share_a_number
    assert_equal(
      post_at("/writing/alpha/").data["num"],
      post_at("/pt/writing/alpha/").data["num"]
    )
  end

  def test_numbers_are_zero_padded_to_three_characters
    @site.posts.docs.each do |doc|
      assert_match(/\A\d{3}\z/, doc.data["num"])
    end
  end

  def test_projects_are_numbered_by_order
    assert_equal "001", project_at(lang: "en", ref: "seq").data["num"]
    assert_equal "002", project_at(lang: "en", ref: "beacon").data["num"]
  end

  def test_project_numbering_restarts_per_language
    # Two English projects precede this one in `order`; if projects were
    # numbered globally instead of per language, this would be "003".
    assert_equal "001", project_at(lang: "pt", ref: "seq").data["num"]
  end

  private

  def post_at(url)
    @site.posts.docs.find { |doc| doc.url == url } ||

      flunk("no post rendered at #{url}")
  end

  def project_at(lang:, ref:)
    @site.collections["projects"].docs.find do |doc|
      doc.data["lang"] == lang && doc.data["ref"] == ref
    end || flunk("no project found for lang=#{lang} ref=#{ref}")
  end
end
