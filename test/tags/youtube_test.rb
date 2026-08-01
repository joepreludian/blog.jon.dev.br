# frozen_string_literal: true

require "test_helper"

# The youtube tag frames a privacy-preserving embed.
class YoutubeTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_renders_the_framed_embed
    html = render(%(id="aqz-KE-bpKQ" caption="demo — sequencer v0.2"))

    assert_includes html, "ds-embed"
    assert_includes html, "ds-embed__frame"
  end

  def test_uses_the_nocookie_domain
    html = render(%(id="aqz-KE-bpKQ" caption="demo"))

    assert_includes html, "youtube-nocookie.com/embed/aqz-KE-bpKQ"
    refute_includes html, "www.youtube.com/embed"
  end

  def test_links_out_to_the_watch_page
    html = render(%(id="aqz-KE-bpKQ" caption="demo"))

    assert_includes html, "youtube.com/watch?v=aqz-KE-bpKQ"
    assert_includes html, "youtube ↗"
  end

  def test_the_iframe_carries_a_title_for_screen_readers
    html = render(%(id="aqz-KE-bpKQ" caption="demo — sequencer v0.2"))

    assert_includes html, %(title="demo — sequencer v0.2")
  end

  def test_the_iframe_is_lazy_loaded
    assert_includes render(%(id="x" caption="c")), %(loading="lazy")
  end

  def test_a_missing_id_fails_the_build
    assert_raises(Liquid::SyntaxError) { render(%(caption="demo")) }
  end

  private

  def render(markup)
    TestHelper.render_liquid("{% youtube #{markup} %}{% endyoutube %}", site: @site)
  end
end
