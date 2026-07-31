# frozen_string_literal: true

require "test_helper"
require "liquid"
require_relative "../../_plugins/jon_dev_br/tags/attributes"

# Keyword-argument parsing for every ds-* Liquid tag.
class AttributesTest < Minitest::Test
  Attributes = JonDevBr::Tags::Attributes

  def test_parses_a_single_pair
    assert_equal({ "lang" => "python" }, Attributes.parse(%(lang="python")))
  end

  def test_parses_several_pairs
    parsed = Attributes.parse(%(lang="python" title="watchdog.py"))

    assert_equal({ "lang" => "python", "title" => "watchdog.py" }, parsed)
  end

  def test_tolerates_spacing_around_the_equals_sign
    assert_equal({ "level" => "NOTE" }, Attributes.parse(%(level = "NOTE")))
  end

  def test_keeps_spaces_and_punctuation_inside_a_value
    parsed = Attributes.parse(%(caption="fig 01 — the whole system."))

    assert_equal "fig 01 — the whole system.", parsed["caption"]
  end

  def test_empty_markup_parses_to_an_empty_hash
    assert_empty Attributes.parse("")
  end

  def test_bang_returns_the_hash_when_requirements_are_met
    parsed = Attributes.parse!(
      %(lang="python"), tag_name: "codeblock", required: ["lang"], optional: ["title"]
    )

    assert_equal({ "lang" => "python" }, parsed)
  end

  def test_bang_raises_when_a_required_key_is_missing
    error = assert_raises(Liquid::SyntaxError) do
      Attributes.parse!(%(title="x"), tag_name: "codeblock", required: ["lang"], optional: ["title"])
    end

    assert_includes error.message, "codeblock"
    assert_includes error.message, "lang"
  end

  def test_bang_raises_on_an_unknown_key
    error = assert_raises(Liquid::SyntaxError) do
      Attributes.parse!(%(lang="ruby" colour="red"), tag_name: "codeblock", required: ["lang"])
    end

    assert_includes error.message, "colour"
  end
end
