# frozen_string_literal: true

require "test_helper"

# The figure tag frames photography. With no image it shows the crosshatch
# placeholder — the design system never illustrates and never generates.
class FigureTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_renders_the_frame_and_the_caption
    html = render(%(src="/assets/img/plane.jpg" alt="A Cessna on short final." caption="short final, SBJD"))

    assert_includes html, "ds-figure"
    assert_includes html, "ds-figure__frame"
    assert_includes html, "short final, SBJD"
  end

  def test_renders_the_image_with_its_alt_text
    html = render(%(src="/assets/img/plane.jpg" alt="A Cessna on short final." caption="c"))

    assert_includes html, %(src="/assets/img/plane.jpg")
    assert_includes html, %(alt="A Cessna on short final.")
  end

  def test_renders_the_exif_meta_line
    html = render(%(src="/a.jpg" alt="a" caption="c" meta="Portra 400 · 50mm"))

    assert_includes html, "Portra 400 · 50mm"
  end

  def test_omitting_src_yields_the_crosshatch_placeholder
    html = render(%(caption="a scan that has not arrived yet"))

    assert_includes html, "ds-figure__ph"
    refute_includes html, "<img"
  end

  def test_images_are_lazy_loaded
    assert_includes render(%(src="/a.jpg" alt="a" caption="c")), %(loading="lazy")
  end

  def test_a_missing_caption_fails_the_build
    assert_raises(Liquid::SyntaxError) { render(%(src="/a.jpg" alt="a")) }
  end

  private

  def render(markup)
    TestHelper.render_liquid("{% figure #{markup} %}{% endfigure %}", site: @site)
  end
end
