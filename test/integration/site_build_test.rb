# frozen_string_literal: true

require "test_helper"

# Whole-site assertions against the real source. The fixture tests prove the
# plugins work; these prove the site does.
class SiteBuildTest < Minitest::Test
  PAGES = [
    "index.html",
    "pt/index.html",
    "writing/index.html",
    "pt/writing/index.html",
    "projects/index.html",
    "pt/projects/index.html",
    "resume/index.html",
    "pt/resume/index.html",
    "404.html",
    "writing/two-of-everything/index.html",
    "feed.xml",
    "pt/feed.xml",
    "robots.txt",
    "sitemap.xml",
    "assets/css/main.css",
    "assets/js/progress.js",
    "assets/favicon.svg"
  ].freeze

  def setup
    @site = TestHelper.build_real_site
    @root = @site.config["destination"]
  end

  def test_every_expected_page_is_written
    PAGES.each { |path| assert_path_exists File.join(@root, path) }
  end

  def test_the_site_actually_has_posts
    # Every other whole-site test below iterates @site.posts.docs. Without
    # this, a defaults scope-path typo or an exclude regression could drop
    # every post and leave those tests passing vacuously against an empty
    # collection — empty archive, empty feeds, a home hero CTA linking to
    # "" — while the suite stays green.
    refute_empty @site.posts.docs
  end

  def test_every_post_has_a_counterpart_in_the_other_language
    by_ref = @site.posts.docs.group_by { |doc| doc.data["ref"] }

    by_ref.each do |ref, docs|
      langs = docs.map { |doc| doc.data["lang"] }.sort

      assert_equal %w[en pt], langs, "post #{ref} is missing a translation"
    end
  end

  def test_hreflang_alternates_are_reciprocal
    english_posts.each do |english|
      portuguese = portuguese_counterpart_of(english)

      assert_includes english.output, %(hreflang="pt-BR" href="#{absolute(portuguese.url)}")
      assert_includes portuguese.output, %(hreflang="en" href="#{absolute(english.url)}")
    end
  end

  def test_entry_numbers_are_contiguous_within_each_language
    @site.posts.docs.group_by { |doc| doc.data["lang"] }.each_value do |docs|
      numbers = docs.map { |doc| doc.data["num"].to_i }.sort

      assert_equal (1..docs.length).to_a, numbers
    end
  end

  def test_every_page_declares_a_document_language
    html_pages.each do |path|
      body = File.read(path)

      assert_match(/<html lang="(en|pt-BR)">/, body, "#{path} has no document language")
    end
  end

  def test_no_page_leaks_an_unrendered_liquid_tag
    html_pages.each do |path|
      body = File.read(path)

      refute_includes body, "{%", "#{path} contains an unrendered Liquid tag"
      refute_includes body, "{{", "#{path} contains an unrendered Liquid expression"
    end
  end

  def test_the_stylesheet_carries_the_orange_palette
    css = File.read(File.join(@root, "assets", "css", "main.css"))

    assert_includes css, "#a84a05"
    assert_includes css, "#ff6a00"
  end

  def test_the_reference_design_is_excluded_from_the_build
    assert_includes @site.config["exclude"], "docs/"
    refute_path_exists File.join(@root, "docs")
  end

  private

  def english_posts
    @site.posts.docs.select { |doc| doc.data["lang"] == "en" }
  end

  def portuguese_counterpart_of(english)
    @site.posts.docs.find do |doc|
      doc.data["ref"] == english.data["ref"] && doc.data["lang"] == "pt"
    end
  end

  def absolute(url)
    "#{@site.config["url"]}#{url}"
  end

  def html_pages
    @html_pages ||= Dir.glob(File.join(@root, "**", "*.html"))
  end
end
