# frozen_string_literal: true

require "test_helper"

# Google Analytics is a production-only script: the measurement id lives in
# _config.yml, and the tag renders only when both the id is set and Jekyll
# runs in the production environment, so a dev server never sends hits.
class AnalyticsTest < Minitest::Test
  ID_FORMAT = /\AG-[A-Z0-9]+\z/

  def setup
    @site = TestHelper.build_real_site
    @root = @site.config["destination"]
  end

  def test_the_configured_id_is_a_ga4_measurement_id
    assert_match ID_FORMAT, @site.config["google_analytics"]
  end

  def test_the_tag_renders_in_production_with_the_configured_id
    id = @site.config["google_analytics"]
    html = render_analytics(environment: "production")

    assert_includes html, %(<script async src="https://www.googletagmanager.com/gtag/js?id=#{id}"></script>)
    assert_includes html, %(gtag("config", "#{id}");)
  end

  def test_nothing_renders_outside_production
    assert_empty render_analytics(environment: "development")
  end

  def test_nothing_renders_without_an_id
    id = @site.config.delete("google_analytics")

    assert_empty render_analytics(environment: "production")
  ensure
    @site.config["google_analytics"] = id
  end

  def test_every_built_page_matches_the_build_environment
    expected = Jekyll.env == "production"

    Dir.glob(File.join(@root, "**", "*.html")).each do |path|
      assert_equal expected, File.read(path).include?("googletagmanager.com/gtag/js"), path
    end
  end

  private

  def render_analytics(environment:)
    TestHelper.render_liquid("{% include analytics.html %}", site: @site, environment: environment).strip
  end
end
