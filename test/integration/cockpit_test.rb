# frozen_string_literal: true

require "test_helper"
require "nokogiri"
require "yaml"

# The hero's control panel. Every lamp and control on it is a real link,
# control or value, so these tests hold each one to the thing it stands for.
class CockpitTest < Minitest::Test
  HOMES = { "en" => "index.html", "pt" => "pt/index.html" }.freeze
  OTHER_HOME = { "en" => "/pt/", "pt" => "/" }.freeze
  PREFIX = { "en" => "", "pt" => "/pt" }.freeze

  def setup
    @site = TestHelper.build_real_site
    @root = @site.config["destination"]
  end

  def test_both_home_pages_carry_the_panel
    HOMES.each_value { |path| refute_nil panel(path), "#{path} has no panel" }
  end

  def test_no_other_page_carries_the_panel
    others = Dir.glob(File.join(@root, "**", "*.html")) - HOMES.values.map { |path| File.join(@root, path) }

    others.each { |path| refute_includes File.read(path), "data-cockpit", "#{path} carries the panel" }
  end

  def test_the_title_bar_is_the_site_host
    HOMES.each_value do |path|
      assert_equal @site.config["url"].sub(%r{\Ahttps?://}, ""), panel(path).at_css(".cockpit__bar").text.strip
    end
  end

  def test_the_lit_language_lamp_is_the_page_language
    HOMES.each do |lang, path|
      lit = panel(path).at_css(".cockpit-lamp[aria-current]")

      assert_equal lang.upcase, lit.text.strip
      assert_includes lit["class"].split, "is-on"
    end
  end

  def test_the_other_language_lamp_and_the_switch_lead_to_the_other_home
    HOMES.each do |lang, path|
      links = panel(path).css("a[hreflang]")

      assert_equal 2, links.length, "#{path} needs a lamp and a switch for the other language"
      links.each { |link| assert_equal OTHER_HOME[lang], link["href"] }
    end
  end

  def test_section_lamps_link_to_the_sections_of_the_page_language
    HOMES.each do |lang, path|
      hrefs = panel(path).css("a.cockpit-lamp").map { |lamp| lamp["href"] }

      %w[/writing/ /projects/ /resume/].each { |section| assert_includes hrefs, "#{PREFIX[lang]}#{section}" }
    end
  end

  def test_the_writing_lamp_counts_the_posts_in_the_page_language
    HOMES.each do |lang, path|
      count = @site.posts.docs.count { |doc| doc.data["lang"] == lang }
      lamp = panel(path).at_css(%(a.cockpit-lamp[href="#{PREFIX[lang]}/writing/"]))

      assert_match(/\A#{format("%03d", count)}\b/, lamp.at_css("small").text)
    end
  end

  def test_the_photo_lamp_opens_the_pexels_profile_in_a_new_tab
    HOMES.each_value do |path|
      lamp = panel(path).at_css(%(a.cockpit-lamp[href="#{@site.config["pexels"]}"]))

      refute_nil lamp, "#{path} has no photo lamp"
      assert_equal "_blank", lamp["target"]
      assert_includes lamp["rel"].split, "noopener"
    end
  end

  def test_the_comments_lamp_is_lit_only_while_giscus_is_configured
    configured = !@site.config.dig("giscus", "repo").to_s.empty?

    HOMES.each_value do |path|
      lamp = panel(path).css(".cockpit-lamp").find { |candidate| candidate.text.include?("giscus") }

      assert_equal configured, lamp["class"].split.include?("is-on"), path
    end
  end

  def test_the_deploy_lamp_shows_the_build_date
    HOMES.each_value do |path|
      assert_includes panel(path).text, @site.time.strftime("%Y-%m-%d")
    end
  end

  # ThemeTest counts exactly two `data-theme-choice` buttons a page. The
  # panel's theme lamps press those through cockpit.js instead of adding more.
  def test_the_theme_lamps_do_not_pose_as_the_header_toggle
    HOMES.each_value do |path|
      lamps = panel(path).css("button[data-cockpit-theme]")

      assert_equal(%w[light dark], lamps.map { |lamp| lamp["data-cockpit-theme"] })
      assert_empty panel(path).css("[data-theme-choice]")
    end
  end

  def test_no_lamp_is_blank
    HOMES.each_value do |path|
      panel(path).css(".cockpit-lamp").each { |lamp| refute_empty lamp.text.strip, "#{path} has a lamp with no legend" }
    end
  end

  def test_both_languages_carry_the_same_legends
    keys = HOMES.keys.map { |lang| YAML.load_file(File.join(TestHelper::ROOT, "_data", "strings", "#{lang}.yml"))["cockpit"].keys.sort }

    refute_empty keys.first
    assert_equal(*keys)
  end

  def test_the_panel_script_is_published_and_deferred
    assert_path_exists File.join(@root, "assets", "js", "cockpit.js")
    HOMES.each_value do |path|
      assert_includes File.read(File.join(@root, path)), %(<script src="/assets/js/cockpit.js" defer></script>)
    end
  end

  private

  def panel(path)
    Nokogiri::HTML(File.read(File.join(@root, path))).at_css("[data-cockpit]")
  end
end
