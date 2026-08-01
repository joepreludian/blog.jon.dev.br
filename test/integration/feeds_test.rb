# frozen_string_literal: true

require "test_helper"

# Each feed lists only its own language. A feed mixing both is the exact
# failure jekyll-feed would have produced, and the reason it is not used.
class FeedsTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
    @root = @site.config["destination"]
  end

  def test_both_feeds_are_written
    assert_path_exists File.join(@root, "feed.xml")
    assert_path_exists File.join(@root, "pt", "feed.xml")
  end

  def test_the_english_feed_excludes_portuguese_entries
    body = read("feed.xml")

    assert_includes body, "/writing/alpha/"
    refute_includes body, "/pt/writing/alpha/"
  end

  def test_the_portuguese_feed_excludes_english_entries
    body = read("pt/feed.xml")

    assert_includes body, "/pt/writing/alpha/"
    refute_includes body, "<id>https://example.test/writing/alpha/</id>"
  end

  def test_each_feed_declares_its_language
    assert_includes read("feed.xml"), %(xml:lang="en")
    assert_includes read("pt/feed.xml"), %(xml:lang="pt-BR")
  end

  def test_entries_use_the_canonical_url_as_their_id
    assert_includes read("feed.xml"), "<id>https://example.test/writing/alpha/</id>"
  end

  def test_feeds_are_excluded_from_the_sitemap
    # `sitemap: false` keeps XML out of the sitemap; without it html-proofer
    # and crawlers both complain.
    refute_includes read("feed.xml"), "<urlset"
  end

  private

  def read(relative)
    File.read(File.join(@root, relative))
  end
end
