# frozen_string_literal: true

require "test_helper"

# The codeblock tag renders a titled terminal panel with Rouge highlighting.
class CodeblockTest < Minitest::Test
  PYTHON = <<~PY
    def check(host):
        return ping(host, timeout=2)  # boring by design
  PY

  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_renders_the_terminal_panel
    html = render(%(lang="python" title="watchdog.py"), PYTHON)

    assert_includes html, "ds-code"
    assert_includes html, "ds-code__bar"
  end

  def test_shows_the_title_and_the_language
    html = render(%(lang="python" title="watchdog.py"), PYTHON)

    assert_includes html, "watchdog.py"
    assert_includes html, %(<span class="ds-code__lang">python</span>)
  end

  def test_highlights_keywords_with_rouge_token_classes
    html = render(%(lang="python"), PYTHON)

    # Rouge marks `def` as a keyword-declaration token.
    assert_match(/class="k[a-z]?"[^>]*>def</, html)
  end

  def test_highlights_comments
    html = render(%(lang="python"), PYTHON)

    # Rouge's canonical shortname for a line comment is "c1" (digit, not a
    # letter) — confirmed directly against Rouge::Token::Tokens for
    # Comment.Single, and already anticipated by the .c1 selector in
    # _sass/components/_code.scss.
    assert_match(/class="c[a-z0-9]?"/, html)
  end

  def test_escapes_html_in_the_source
    html = render(%(lang="python"), "x = a < b")

    assert_includes html, "&lt;"
    refute_includes html, "a < b"
  end

  def test_the_title_bar_omits_the_title_when_none_is_given
    html = render(%(lang="python"), PYTHON)

    assert_includes html, "ds-code__lang"
    refute_includes html, "ds-code__title"
  end

  def test_an_unknown_language_falls_back_to_plain_text
    html = render(%(lang="klingon"), "qapla")

    assert_includes html, "ds-code"
    assert_includes html, "qapla"
  end

  def test_a_missing_lang_fails_the_build
    assert_raises(Liquid::SyntaxError) { render(%(title="x.py"), PYTHON) }
  end

  private

  def render(markup, body)
    TestHelper.render_liquid(
      "{% codeblock #{markup} %}#{body}{% endcodeblock %}", site: @site
    )
  end
end
