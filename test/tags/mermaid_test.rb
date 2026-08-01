# frozen_string_literal: true

require "test_helper"

# The mermaid tag frames a diagram and carries its source in the markup.
class MermaidTest < Minitest::Test
  GRAPH = <<~MMD
    flowchart LR
      C[client] --> D[dns]
      D --> P[primary]
  MMD

  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_renders_the_framed_figure
    html = render(%(caption="fig 01 — the whole system."), GRAPH)

    assert_includes html, "ds-mermaid"
    assert_includes html, "ds-mermaid__frame"
  end

  def test_marks_the_diagram_for_the_bootstrap_hook
    html = render(%(caption="fig 01"), GRAPH)

    assert_includes html, "data-mermaid"
    assert_includes html, %(class="mermaid")
  end

  def test_carries_the_graph_source_in_the_markup
    html = render(%(caption="fig 01"), GRAPH)

    assert_includes html, "flowchart LR"
  end

  def test_escapes_the_graph_source
    # Mermaid reads textContent, so escaping is both correct and required.
    html = render(%(caption="fig 01"), "flowchart LR\n  A[a & b] --> B")

    assert_includes html, "&amp;"
  end

  def test_renders_the_caption_and_the_fixed_meta_label
    html = render(%(caption="fig 01 — the investigation pipeline."), GRAPH)

    assert_includes html, "fig 01 — the investigation pipeline."
    assert_includes html, "fig · mermaid"
  end

  def test_a_missing_caption_fails_the_build
    assert_raises(Liquid::SyntaxError) { render("", GRAPH) }
  end

  private

  def render(markup, body)
    TestHelper.render_liquid(
      "{% mermaid #{markup} %}#{body}{% endmermaid %}", site: @site
    )
  end
end
