# frozen_string_literal: true

require "test_helper"

# The reading_time filter turns rendered content into a minute count.
class ReadingTimeTest < Minitest::Test
  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_rounds_up_to_the_next_whole_minute
    # 201 words at 200 wpm is two minutes, not one.
    words = (["word"] * 201).join(" ")

    assert_equal 2, render(words)
  end

  def test_never_returns_less_than_one_minute
    assert_equal 1, render("three short words")
  end

  def test_ignores_markup_when_counting
    # 200 words sits exactly on the one-minute boundary at 200 wpm. The six
    # tags below are surrounded by whitespace, so an implementation that
    # failed to strip them would count each as its own token — 206 words,
    # two minutes — comfortably past a one-token margin. Only correctly
    # stripping the tags keeps this at one minute.
    words = (["word"] * 200).join(" ")
    html = "<p> #{words} </p> <pre> <code> </code> </pre>"

    assert_equal 1, render(html)
  end

  def test_honours_the_configured_words_per_minute
    site = TestHelper.build_fixture_site("words_per_minute" => 100)
    words = (["word"] * 150).join(" ")

    assert_equal 2, TestHelper.render_liquid(
      "{{ page.body | reading_time }}", site: site, page: { "body" => words }
    ).to_i
  end

  def test_empty_content_is_one_minute
    assert_equal 1, render("")
  end

  private

  def render(body)
    TestHelper.render_liquid(
      "{{ page.body | reading_time }}", site: @site, page: { "body" => body }
    ).to_i
  end
end
