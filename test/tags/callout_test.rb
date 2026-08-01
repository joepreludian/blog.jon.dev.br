# frozen_string_literal: true

require "test_helper"

# The callout tag renders aviation placards. Levels are bilingual and the
# literal the author writes is what appears in the output.
class CalloutTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_note_renders_the_note_variant
    html = render(%(level="NOTE"), "Redundancy you have never exercised is decoration.")

    assert_includes html, "ds-callout--note"
    assert_includes html, "NOTE"
    assert_includes html, "Redundancy you have never exercised is decoration."
  end

  def test_caution_renders_the_caution_variant
    html = render(%(level="CAUTION"), "Queues are at-least-once.")

    assert_includes html, "ds-callout--caution"
  end

  def test_warning_renders_the_warning_variant
    assert_includes render(%(level="WARNING"), "Body."), "ds-callout--warning"
  end

  def test_portuguese_levels_map_to_the_same_variants
    assert_includes render(%(level="NOTA"), "Corpo."), "ds-callout--note"
    assert_includes render(%(level="CUIDADO"), "Corpo."), "ds-callout--caution"
    assert_includes render(%(level="AVISO"), "Corpo."), "ds-callout--warning"
  end

  def test_the_level_renders_as_written_not_normalised
    # A PT post must read as a PT placard.
    assert_includes render(%(level="CUIDADO"), "Corpo."), ">CUIDADO<"
  end

  def test_the_body_is_rendered_as_markdown
    html = render(%(level="NOTE"), "Rule of thumb since *2019*.")

    assert_includes html, "<em>2019</em>"
  end

  def test_an_unknown_level_fails_the_build
    error = assert_raises(Liquid::SyntaxError) do
      render(%(level="DANGER"), "Body.")
    end

    assert_includes error.message, "DANGER"
  end

  def test_a_missing_level_fails_the_build
    assert_raises(Liquid::SyntaxError) { render("", "Body.") }
  end

  private

  def render(markup, body)
    TestHelper.render_liquid(
      "{% callout #{markup} %}#{body}{% endcallout %}", site: @site
    )
  end
end
