# frozen_string_literal: true

require "test_helper"

# The light and dark themes differ only in their role tokens. These tests
# keep it that way: a component that reached for a raw palette colour would
# silently keep its light value in the dark theme.
class ThemeTest < Minitest::Test
  SASS_DIR = File.join(TestHelper::ROOT, "_sass")
  PALETTE = File.join(SASS_DIR, "tokens", "_colors.scss")
  RAW_PALETTE = /var\(--(?:paper-|ink-|white\b|line-|graphite-|accent-\d)/
  COLOUR_LITERAL = /#\h{3,8}\b|\brgba?\(/

  def test_only_the_palette_file_names_a_raw_colour
    offences = sass_lines.select { |_, _, code| code.match?(RAW_PALETTE) || code.match?(COLOUR_LITERAL) }

    assert_empty offences.map { |path, number, code| "#{path}:#{number}: #{code.strip}" },
                 "use a role token from _sass/tokens/_colors.scss instead"
  end

  private

  # Every line of every partial except the palette, with `//` comments
  # stripped so prose that mentions a colour does not count.
  def sass_lines
    paths = Dir.glob(File.join(SASS_DIR, "**", "*.scss")) - [PALETTE]
    paths.flat_map do |path|
      relative = path.delete_prefix("#{TestHelper::ROOT}/")
      File.readlines(path).each_with_index.map { |line, index| [relative, index + 1, line.sub(%r{//.*}, "")] }
    end
  end
end
