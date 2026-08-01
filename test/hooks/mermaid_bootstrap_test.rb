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

  def test_the_theme_uses_the_orange_palette
    output = output_at("/writing/gamma/")

    assert_includes output, "#a84a05"
    assert_includes output, "IBM Plex Mono"
  end

  private

  def output_at(url)
    doc = @site.posts.docs.find { |d| d.url == url }
    doc ? doc.output : flunk("no post rendered at #{url}")
  end
end
