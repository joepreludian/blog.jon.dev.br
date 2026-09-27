# frozen_string_literal: true

require "test_helper"

# The Mermaid loader must appear on documents that contain a diagram and
# nowhere else — it is a large dependency.
class MermaidBootstrapTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_injects_the_loader_into_a_document_with_a_diagram
    output = output_at("/writing/gamma/")

    assert_includes output, "mermaid.min.js"
    assert_includes output, "mermaid.initialize"
  end

  def test_leaves_documents_without_a_diagram_alone
    refute_includes output_at("/writing/alpha/"), "mermaid.min.js"
  end

  def test_injects_the_loader_exactly_once
    assert_equal 1, output_at("/writing/gamma/").scan("mermaid.min.js").length
  end

  def test_the_script_carries_an_integrity_hash
    output = output_at("/writing/gamma/")

    assert_includes output, "integrity=\"sha384-"
    assert_includes output, 'crossorigin="anonymous"'
  end

  # The diagram theme is read from the page's role tokens at runtime, so it
  # follows the light and dark themes without a second palette in Ruby.
  def test_the_theme_is_read_from_the_role_tokens
    output = output_at("/writing/gamma/")

    assert_includes output, "--accent-label"
    assert_includes output, "--font-mono"
    refute_match(/#\h{6}/, output[output.index("mermaid.min.js")..])
  end

  def test_diagrams_redraw_when_the_theme_changes
    assert_includes output_at("/writing/gamma/"), 'addEventListener("themechange"'
  end

  # Posts render with layout: null in this fixture site, so every assertion
  # above exercises only the `:documents` registration and the append
  # branch of `inject`. This fixture page has a real layout with a <body>,
  # so it exercises the `:pages` registration and the substitution branch.
  def test_injects_the_loader_into_a_page_with_a_diagram
    assert_includes page_output_at("/diagram-page.html"), "mermaid.min.js"
  end

  def test_inserts_the_loader_before_the_closing_body_tag
    output = page_output_at("/diagram-page.html")
    script_index = output.index("mermaid.min.js")
    body_close_index = output.index("</body>")

    refute_nil script_index, "expected mermaid.min.js in the page output"
    refute_nil body_close_index, "expected the page layout to carry </body>"
    assert_operator script_index, :<, body_close_index
  end

  private

  def output_at(url)
    doc = @site.posts.docs.find { |d| d.url == url }
    doc ? doc.output : flunk("no post rendered at #{url}")
  end

  def page_output_at(url)
    page = @site.pages.find { |p| p.url == url }
    page ? page.output : flunk("no page rendered at #{url}")
  end
end
