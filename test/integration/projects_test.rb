# frozen_string_literal: true

require "test_helper"

# The projects collection is a registry: no per-project pages, both languages
# present, and every status maps to a known badge variant.
class ProjectsTest < Minitest::Test
  KNOWN_STATUSES = %w[flying hangared grounded].freeze

  def setup
    @site = TestHelper.build_fixture_site
  end

  def test_projects_do_not_get_their_own_pages
    refute_predicate @site.collections["projects"], :write?,
                     "the projects collection must be output: false"
  end

  def test_both_languages_are_present
    langs = @site.collections["projects"].docs.map { |doc| doc.data["lang"] }.uniq.sort

    assert_equal %w[en pt], langs
  end

  def test_paired_projects_share_a_ref
    refs = @site.collections["projects"].docs.group_by { |doc| doc.data["ref"] }

    refs.each_value do |docs|
      assert_equal 2, docs.length, "each project needs an EN and a PT entry"
    end
  end

  def test_every_status_is_one_the_theme_can_render
    @site.collections["projects"].docs.each do |doc|
      assert_includes KNOWN_STATUSES, doc.data["status"]
    end
  end

  def test_every_project_declares_an_order
    @site.collections["projects"].docs.each do |doc|
      assert_kind_of Integer, doc.data["order"]
    end
  end
end
