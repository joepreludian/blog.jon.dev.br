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

  def test_the_sitemap_is_generated_and_lists_the_fixtures_own_pages
    # Proves jekyll-sitemap actually ran against the fixture and produced a
    # real sitemap containing real pages, so the exclusion check below is
    # against a document that could have leaked the feeds, not an empty one.
    assert_path_exists File.join(@root, "sitemap.xml")
    assert_includes read("sitemap.xml"), "/writing/alpha/"
  end

  def test_feeds_are_excluded_from_the_sitemap
    # `sitemap: false` keeps the feeds and the 404 page out of jekyll-sitemap's
    # output; without it html-proofer and crawlers both complain. Assert
    # against the actual generated sitemap.xml, not the feed files themselves —
    # a feed can never contain sitemap markup, so that would pass regardless
    # of the flag.
    sitemap = read("sitemap.xml")

    refute_includes sitemap, "feed.xml"
    refute_includes sitemap, "404.html"
  end

  private

  def read(relative)
    File.read(File.join(@root, relative))
  end
end
