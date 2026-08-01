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

  def test_the_sitemap_excludes_the_feeds_and_the_404_page
    # This is a property guard, not a behavioural test of `sitemap: false`.
    #
    # Under jekyll-sitemap 1.4.0, this assertion cannot currently be driven
    # red by removing `sitemap: false` from feed.xml, pt/feed.xml, or 404.html
    # — verified directly against the gem's bundled sitemap.xml template.
    # It loops over `site.html_pages`, a Jekyll-core collection already
    # filtered to `.html`-extension output, so the two `.xml` feeds are never
    # candidates in the first place and the `doc.sitemap != false` check is
    # never reached for them. Separately, the template hardcodes
    # `doc.url != "/404.html"`, excluding our 404 page by URL regardless of
    # its own flag. `sitemap: false` on all three files is therefore
    # belt-and-braces, not the mechanism — it costs nothing and stays correct
    # if the plugin's filtering ever changes, but it is not what this test
    # exercises.
    #
    # What the assertion protects is the outcome for *our* configuration: if
    # a future change renamed the 404 page, moved it off `/404.html`, gave a
    # feed an `.html` permalink, or swapped the sitemap plugin, these URLs
    # could start being indexed by search engines. This test exists to catch
    # that regression, even though nothing in the current suite can force it
    # to fail on its own — a future jekyll-sitemap upgrade is the only thing
    # likely to.
    sitemap = read("sitemap.xml")

    refute_includes sitemap, "feed.xml"
    refute_includes sitemap, "404.html"
  end

  private

  def read(relative)
    File.read(File.join(@root, relative))
  end
end
