# frozen_string_literal: true

require "json"

module JonDevBr
  module Hooks
    # Injects the Mermaid loader into rendered documents that actually contain
    # a diagram, and nowhere else.
    #
    # A front-matter flag would be bookkeeping the author forgets; an
    # unconditional include would put a ~2.7MB dependency on every page. The
    # marker is the opening `<pre class="mermaid" data-mermaid>` tag emitted
    # by the mermaid Liquid tag — matched as a real tag, not a bare substring.
    #
    # Both Atom feeds embed `{{ post.content | strip_newlines | xml_escape }}`,
    # and `xml_escape` does not touch attribute *names* — only the surrounding
    # markup gets entity-escaped — so a naive substring marker like
    # `"data-mermaid"` would still match inside a feed, where there is no
    # `</body>` to insert before and the append fallback would tack raw
    # `<script>` tags on after `</feed>`, corrupting the XML. Belt-and-braces
    # against that: the hook only ever runs on `.html` output (checked via
    # `output_ext`, confirmed present on both `Jekyll::Page` and
    # `Jekyll::Document` in the pinned Jekyll 4.4.1), and the marker itself
    # requires the literal, unescaped `<pre ...>` tag, so even an `.html`
    # document could not match it once the content has gone through
    # `xml_escape` (which would turn the `"` and `<` into entities).
    #
    # The `(?:="")?` tolerates a quirk of the real pipeline: the mermaid tag
    # itself emits a bare boolean `data-mermaid` (no `="..."`), but Kramdown
    # parses that raw HTML block into its own element tree and re-serialises
    # it, and its HTML converter always writes a value — turning the boolean
    # attribute into `data-mermaid=""` by the time it reaches this hook.
    # Confirmed directly against the fixture's rendered post output.
    module MermaidBootstrap
      MARKER = /<pre class="mermaid" data-mermaid(?:="")?>/
      VERSION = "10.9.1"
      SRI = "sha384-WmdflGW9aGfoBdHc4rRyWzYuAjEmDwMdGdiPNacbwfGKxBW/SO6guzuQ76qjnSlr"

      # Mermaid theme variables, each read from a role token on <html> at
      # draw time, so diagrams follow the light and dark themes without a
      # second palette here. In light, every token resolves to the colour
      # this hook used to hard-code from the reference design.
      THEME_TOKENS = {
        primaryColor: "--surface-hover",
        mainBkg: "--surface-hover",
        primaryBorderColor: "--border-strong",
        nodeBorder: "--border-strong",
        primaryTextColor: "--text-body",
        textColor: "--text-secondary",
        lineColor: "--accent-label",
        secondaryColor: "--surface-inset",
        clusterBkg: "--surface-inset",
        tertiaryColor: "--surface-card",
        edgeLabelBackground: "--surface-page"
      }.freeze

      # Mermaid draws once, replacing each <pre> with an SVG. To redraw on a
      # theme change, keep every diagram's source, put it back, clear
      # Mermaid's `data-processed` marker and run again. The first draw
      # waits for `load`, as `startOnLoad` did, so the fonts are in.
      LOADER = <<~JS.freeze
        (function () {
          var tokens = #{JSON.generate(THEME_TOKENS)};
          var root = document.documentElement;
          var nodes = Array.prototype.slice.call(document.querySelectorAll("pre.mermaid[data-mermaid]"));
          var sources = nodes.map(function (node) { return node.textContent; });

          function dark() {
            var chosen = root.getAttribute("data-theme");
            if (chosen === "light" || chosen === "dark") return chosen === "dark";
            return window.matchMedia("(prefers-color-scheme: dark)").matches;
          }

          function config() {
            var style = window.getComputedStyle(root);
            var read = function (name) { return style.getPropertyValue(name).trim(); };
            var themeVariables = { fontSize: "13px", darkMode: dark() };
            Object.keys(tokens).forEach(function (key) { themeVariables[key] = read(tokens[key]); });
            return { startOnLoad: false, theme: "base", fontFamily: read("--font-mono"), themeVariables: themeVariables };
          }

          function render() {
            nodes.forEach(function (node, i) {
              node.removeAttribute("data-processed");
              node.textContent = sources[i];
            });
            mermaid.initialize(config());
            mermaid.run({ nodes: nodes }).catch(function (error) { console.error(error); });
          }

          mermaid.initialize({ startOnLoad: false });
          if (document.readyState === "complete") render();
          else window.addEventListener("load", render);
          document.addEventListener("themechange", render);
        })();
      JS

      def self.snippet
        <<~HTML
          <script src="https://cdn.jsdelivr.net/npm/mermaid@#{VERSION}/dist/mermaid.min.js"
                  integrity="#{SRI}" crossorigin="anonymous"></script>
          <script>
          #{LOADER}</script>
        HTML
      end

      # Inserts before </body> when a layout provided one; appends otherwise,
      # so layout-less documents (and the test fixtures) still work.
      def self.inject(output)
        return output unless output.match?(MARKER)
        return output if output.include?("mermaid.min.js")

        if output.include?("</body>")
          output.sub("</body>", "#{snippet}</body>")
        else
          output + snippet
        end
      end

      def self.install
        %i[documents pages].each do |owner|
          Jekyll::Hooks.register(owner, :post_render) do |item|
            next unless item.output_ext == ".html"

            item.output = inject(item.output)
          end
        end
      end
    end
  end
end

JonDevBr::Hooks::MermaidBootstrap.install
