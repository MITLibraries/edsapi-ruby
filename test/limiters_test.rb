require_relative 'test_helper'

class EdsApiTests < Minitest::Test

  def test_known_limiters
    VCR.use_cassette('limiters_test/profile_1/test_known_limiters') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'volcano', results_per_page: 1, limiters: ['FT:Y', 'RV:Y']})
      refute_nil results
      applied_limiters = results.applied_limiters.map{|hash| hash['Id']}
      assert applied_limiters.include? 'FT'
      assert applied_limiters.include? 'RV'
      session.end
    end
  end

  def test_unknown_limiters_ids
    VCR.use_cassette('limiters_test/profile_1/test_unknown_limiters_ids') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'volcano', results_per_page: 1, limiters: ['XX:Y', 'YY:Y']})
      refute_nil results
      applied_limiters = results.applied_limiters.map{|hash| hash['Id']}
      assert applied_limiters.empty?
      session.end
    end
  end

  def test_unavailable_limiter_values
    VCR.use_cassette('limiters_test/profile_1/test_unavailable_limiter_values') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'volcano', results_per_page: 1, limiters: ['LA99:PigLatin']})
      refute_nil results
      applied_limiters = results.applied_limiters.map{|hash| hash['Id']}
      assert applied_limiters.empty?
      session.end
    end
  end

  def test_some_unavailable_limiter_values
    VCR.use_cassette('limiters_test/profile_1/test_some_unavailable_limiter_values') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'volcano', results_per_page: 1, limiters: ['LA99:French,PigLatin']})
      refute_nil results
      lang_limiters = results.applied_limiters.find{|item| item['Id'] == 'LA99'}
      lang_values = lang_limiters['LimiterValuesWithAction'][0].fetch('Value')
      assert lang_values == 'French'
      session.end
    end
  end

  # should be less than 10 result differences between the api and eds date syntax
  def test_both_date_limiter_syntaxes
    VCR.use_cassette('limiters_test/profile_1/test_both_date_limiter_syntaxes') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results_api_date = session.search({query: 'volcano', limters: ['DT1:2014-01/2014-12']})
      results_eds_date = session.search({query: 'volcano', limters: ['DT1:20140101-20141231']})
      results_dif = (results_api_date.stat_total_hits - results_eds_date.stat_total_hits).abs
      assert results_dif.between?(0, 10)
      session.end
    end
  end

  def test_add_limiter
    VCR.use_cassette('limiters_test/profile_1/test_add_limiter') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'patriots', results_per_page: 1})
      results2 = session.add_limiter('FT', 'y')
      assert results.stat_total_hits > results2.stat_total_hits
      session.end
    end
  end

  def test_remove_limiter
    VCR.use_cassette('limiters_test/profile_1/test_remove_limiter') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'patriots', results_per_page: 1})
      results2 = session.add_limiter('FT', 'y')
      assert results.stat_total_hits > results2.stat_total_hits
      results3 = session.remove_limiter('FT')
      assert results3.stat_total_hits > results2.stat_total_hits
      session.end
    end
  end

  def test_remove_limiter_value
    VCR.use_cassette('limiters_test/profile_1/test_remove_limiter_value') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'patriots', results_per_page: 1})
      results2 = session.add_limiter('LA99', 'French,English')
      assert results.stat_total_hits > results2.stat_total_hits
      # API bug?
      # EdsApiTests#test_remove_limiter_value:
      # EBSCO::EDS::BadRequest: {"DetailedErrorDescription"=>"", "ErrorDescription"=>"Unknown error encountered", "ErrorNumber"=>"106"}
      assert_raises EBSCO::EDS::BadRequest do
        session.remove_limiter_value('LA99', 'English')
      end
      #assert results3.stat_total_hits < results2.stat_total_hits
      session.end
    end
  end

  def test_clear_limiters
    VCR.use_cassette('limiters_test/profile_1/test_clear_limiters') do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      results = session.search({query: 'patriots', results_per_page: 1})
      results2 = session.add_limiter('FT', 'y')
      assert results.stat_total_hits > results2.stat_total_hits
      results3 = session.clear_limiters
      assert results3.stat_total_hits > results2.stat_total_hits
      session.end
    end
  end

end