# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "jekyll"

# Shared helpers for building the fixture site and rendering Liquid in
# isolation. Every plugin test goes through here.
module TestHelper
  ROOT = File.expand_path("..", __dir__)
  FIXTURE_SOURCE = File.join(__dir__, "fixtures", "site")

  # Builds the fixture site into a fresh temp directory and returns the
  # built Jekyll::Site. Pass `overrides` to change config per test.
  def self.build_fixture_site(overrides = {})
    destination = Dir.mktmpdir("jon-dev-br-test")
    config = Jekyll.configuration(
      {
        "source" => FIXTURE_SOURCE,
        "destination" => destination,
        "plugins_dir" => File.join(ROOT, "_plugins"),
        "quiet" => true
      }.merge(overrides)
    )

    site = Jekyll::Site.new(config)
    site.process
    site
  end

  # Builds the repository's own site into a fresh temp directory. Slower than
  # the fixture build, so only whole-site assertions should use it.
  def self.build_real_site
    @build_real_site ||= begin
      destination = Dir.mktmpdir("jon-dev-br-real")
      config = Jekyll.configuration(
        "source" => ROOT,
        "destination" => destination,
        "quiet" => true
      )
      site = Jekyll::Site.new(config)
      site.process
      site
    end
  end

  # Renders a Liquid template against a built site. `page` seeds the
  # `page` drop, which tags and filters read for `lang` and `ref`.
  def self.render_liquid(template, site:, page: {})
    info = { registers: { site: site, page: page } }
    Liquid::Template
      .parse(template)
      .render!({ "page" => page, "site" => site.site_payload["site"] }, info)
  end
end
