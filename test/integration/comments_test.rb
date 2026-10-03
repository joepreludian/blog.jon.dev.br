# frozen_string_literal: true

require "test_helper"
require "nokogiri"

# giscus finds a post's GitHub Discussion by the term a page hands it, so each
# language gets its own thread only if the terms differ between a post's pair.
class CommentsTest < Minitest::Test
  def setup
    @site = TestHelper.build_real_site
    @root = @site.config["destination"]
  end

  def test_every_post_has_a_comments_section
    @site.posts.docs.each do |post|
      refute_nil comments_in(post.url), "#{post.url} has no comments section"
    end
  end

  def test_every_section_points_at_the_configured_repo_and_category
    expected = @site.config["giscus"].values_at("repo", "repo_id", "category", "category_id")

    @site.posts.docs.each do |post|
      section = comments_in(post.url)
      actual = %w[data-repo data-repo-id data-category data-category-id].map { |name| section[name] }

      assert_equal expected, actual, post.url
    end
  end

  def test_each_thread_is_keyed_on_ref_and_language
    @site.posts.docs.each do |post|
      expected = "#{post.data["ref"]}-#{post.data["lang"]}"

      assert_equal expected, comments_in(post.url)["data-term"], post.url
    end
  end

  def test_the_two_languages_of_a_post_get_different_threads
    @site.posts.docs.group_by { |post| post.data["ref"] }.each do |ref, pair|
      terms = pair.map { |post| comments_in(post.url)["data-term"] }

      assert_equal terms.uniq, terms, "#{ref} shares a thread between languages"
    end
  end

  def test_each_language_loads_giscus_in_its_own_language
    @site.posts.docs.each do |post|
      assert_equal post.data["lang"], comments_in(post.url)["data-language"], post.url
    end
  end

  def test_pages_that_are_not_posts_have_no_comments
    %w[index.html pt/index.html writing/index.html projects/index.html resume/index.html].each do |path|
      html = Nokogiri::HTML(File.read(File.join(@root, path)))

      assert_nil html.at_css("[data-comments]"), "#{path} has a comments section"
    end
  end

  def test_a_post_can_opt_out
    assert_empty render_comments("comments" => false)
  end

  def test_nothing_renders_without_a_repo
    giscus = @site.config.delete("giscus")

    assert_empty render_comments
  ensure
    @site.config["giscus"] = giscus
  end

  private

  def comments_in(url)
    path = File.join(@root, url, "index.html")
    Nokogiri::HTML(File.read(path)).at_css("[data-comments]")
  end

  def render_comments(page = {})
    page = { "lang" => "en", "ref" => "x", "url" => "/writing/x/", "title" => "x" }.merge(page)
    TestHelper.render_liquid("{% include comments.html %}", site: @site, page: page).strip
  end
end
