# frozen_string_literal: true

require "test_helper"
require "yaml"

# Resume data must be structurally identical across languages. A key present
# in one and missing in the other renders as blank with no build warning.
class ResumeTest < Minitest::Test
  REQUIRED_KEYS = %w[headline summary experience skills education contact].freeze

  def setup
    @data = %w[en pt].to_h do |lang|
      [lang, YAML.safe_load_file(
        File.join(TestHelper::ROOT, "_data", "resume", "#{lang}.yml"),
        permitted_classes: [Date]
      )]
    end
  end

  def test_both_languages_declare_every_top_level_key
    @data.each do |lang, data|
      REQUIRED_KEYS.each do |key|
        assert_includes data.keys, key, "#{lang}.yml is missing #{key}"
      end
    end
  end

  def test_both_languages_list_the_same_number_of_jobs
    assert_equal @data["en"]["experience"].length, @data["pt"]["experience"].length
  end

  def test_both_languages_list_the_same_number_of_education_entries
    assert_equal @data["en"]["education"].length, @data["pt"]["education"].length
  end

  def test_both_languages_list_the_same_number_of_contact_entries
    assert_equal @data["en"]["contact"].length, @data["pt"]["contact"].length
  end

  def test_both_languages_list_the_same_skills_in_the_same_order
    assert_equal(
      @data["en"]["skills"].map { |s| s["label"] },
      @data["pt"]["skills"].map { |s| s["label"] }
    )
  end

  def test_every_job_declares_role_org_from_and_to
    @data.each_value do |data|
      data["experience"].each do |job|
        %w[role org from to].each { |key| assert job[key], "job missing #{key}" }
      end
    end
  end

  def test_contact_entries_all_carry_an_href
    @data.each_value do |data|
      data["contact"].each { |entry| assert entry["href"] }
    end
  end
end
