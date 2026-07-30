# frozen_string_literal: true

require "test_helper"

# Verifies the bilingual content model: permalinks, language assignment,
# and pairing by `ref`.
class ContentModelTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_english_posts_live_under_writing
    assert_includes urls, "/writing/alpha/"
    assert_includes urls, "/writing/beta/"
  end

  def test_portuguese_posts_live_under_pt_writing
    assert_includes urls, "/pt/writing/alpha/"
  end

  def test_language_is_assigned_from_the_directory
    assert_equal "en", post_at("/writing/alpha/").data["lang"]
    assert_equal "pt", post_at("/pt/writing/alpha/").data["lang"]
  end

  def test_paired_posts_share_a_ref_and_a_date
    english = post_at("/writing/alpha/")
    portuguese = post_at("/pt/writing/alpha/")

    assert_equal english.data["ref"], portuguese.data["ref"]
    assert_equal english.date.to_date, portuguese.date.to_date
  end

  def test_an_untranslated_post_has_no_counterpart
    counterparts = @site.posts.docs.select do |doc|
      doc.data["ref"] == "beta" && doc.data["lang"] == "pt"
    end

    assert_empty counterparts
  end

  def test_ui_strings_exist_for_every_configured_language
    # The real site carries _data/strings; the fixture does not, so this
    # asserts against the repository's own data directory.
    strings_dir = File.join(TestHelper::ROOT, "_data", "strings")

    @site.config["languages"].each do |lang|
      assert_path_exists File.join(strings_dir, "#{lang}.yml")
    end
  end

  private

  def urls
    @urls ||= @site.posts.docs.map(&:url)
  end

  def post_at(url)
    @site.posts.docs.find { |doc| doc.url == url } ||

      flunk("no post rendered at #{url}")
  end
end
