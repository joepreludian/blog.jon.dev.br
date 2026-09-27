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
  # Tokens that are the same in every theme, so the dark block skips them.
  THEME_INDEPENDENT = /\A--(?:paper-|ink-|white\z|line-|graphite-|accent-\d|accent-bright\z|terminal-)/
  DARK_CHOSEN = /:root\[data-theme="?dark"?\]\{([^}]*)\}/
  DARK_DEVICE = /@media\s*\(prefers-color-scheme:\s*dark\)\s*\{\s*:root:not\(\[data-theme="?light"?\]\)\s*\{([^}]*)\}/

  def setup
    @root = TestHelper.build_real_site.config["destination"]
  end

  def test_only_the_palette_file_names_a_raw_colour
    offences = sass_lines.select { |_, _, code| code.match?(RAW_PALETTE) || code.match?(COLOUR_LITERAL) }

    assert_empty offences.map { |path, number, code| "#{path}:#{number}: #{code.strip}" },
                 "use a role token from _sass/tokens/_colors.scss instead"
  end

  def test_the_dark_theme_applies_when_chosen_and_when_the_device_prefers_it
    chosen = stylesheet[DARK_CHOSEN, 1]
    device = stylesheet[DARK_DEVICE, 1]

    refute_nil chosen, "no :root[data-theme=dark] block in main.css"
    refute_nil device, "no prefers-color-scheme: dark block in main.css"
    assert_equal chosen, device
  end

  def test_every_role_token_has_a_dark_value
    light_roles = tokens_in(stylesheet[/:root\{([^}]*)\}/, 1]).grep_v(THEME_INDEPENDENT)

    assert_empty light_roles - tokens_in(stylesheet[DARK_CHOSEN, 1]), "these roles keep their light value in dark"
  end

  def test_every_page_offers_the_theme_toggle
    Dir.glob(File.join(@root, "**", "*.html")).each do |path|
      assert_equal 2, File.read(path).scan("data-theme-choice=").length, "#{path} lacks the theme toggle"
    end
  end

  def test_the_toggle_is_labelled_in_the_page_language
    { "index.html" => %w[light dark], "pt/index.html" => %w[claro escuro] }.each do |path, (light, dark)|
      body = page(path)

      assert_match(%r{data-theme-choice="light"[^>]*>#{light}</button>}, body)
      assert_match(%r{data-theme-choice="dark"[^>]*>#{dark}</button>}, body)
    end
  end

  def test_the_toggle_is_hidden_when_scripts_cannot_run
    assert_match(/html:not\(\.js\)\s*\.theme-toggle\s*\{\s*display:\s*none/, stylesheet)
  end

  # A saved choice must be on <html> before the first paint, or a reader who
  # picked dark sees a flash of the light page on every load.
  def test_the_saved_theme_is_applied_before_the_stylesheet_loads
    body = page("index.html")
    boot = body.index('localStorage.getItem("theme")')

    refute_nil boot, "no inline boot script reading the saved theme"
    assert_includes body, 'classList.add("js")'
    assert_operator boot, :<, body.index("/assets/css/main.css")
  end

  def test_the_theme_script_is_published_and_deferred
    assert_path_exists File.join(@root, "assets", "js", "theme.js")
    assert_includes page("index.html"), %(<script src="/assets/js/theme.js" defer></script>)
  end

  # Meta tags cannot read CSS, so these two hex values are the one place the
  # page surfaces are written down twice.
  def test_the_browser_chrome_matches_the_page_surface_in_each_theme
    palette = File.read(PALETTE)
    dark_name = palette[/@mixin dark-roles.*?--surface-page:\s*var\((--[\w-]+)\)/m, 1]
    surfaces = { "light" => palette[/--paper-0:\s*(#\h{6})/, 1], "dark" => palette[/#{dark_name}:\s*(#\h{6})/, 1] }

    surfaces.each do |scheme, colour|
      assert_includes page("index.html"),
                      %(<meta name="theme-color" content="#{colour}" media="(prefers-color-scheme: #{scheme})">)
    end
  end

  private

  def stylesheet
    @stylesheet ||= File.read(File.join(@root, "assets", "css", "main.css"))
  end

  def page(path)
    File.read(File.join(@root, path))
  end

  def tokens_in(block)
    block.to_s.scan(/(--[\w-]+)\s*:/).flatten
  end

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
