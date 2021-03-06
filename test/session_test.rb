require_relative 'test_helper'

class EdsApiTests < Minitest::Test

  def test_create_session_with_user_credentials
    VCR.use_cassette('session_test/profile_1/test_create_session_with_user_credentials', :allow_playback_repeats => true) do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api', user: 'billmckinn', auth: 'user'})
      refute_nil session.session_token, 'Expected session token not to be nil.'
      refute_nil session.auth_token, 'Expected auth token not to be nil.'
      session.end
    end
  end

  # def test_create_session_with_ip
  #   VCR.use_cassette('test_create_session_with_ip') do
  #           session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api', user: nil, pass: nil, auth: 'ip'})
  #           assert session.session_token != nil, 'Expected session token not to be nil.'
  #           session.end
  #   end
  # end

  def test_create_session_missing_profile
    VCR.use_cassette('session_test/test_create_session_missing_profile', :allow_playback_repeats => true) do
      e = assert_raises EBSCO::EDS::InvalidParameter do
        EBSCO::EDS::Session.new({use_cache: false, profile: ''})
      end
      assert_match 'Session must specify a valid api profile.', e.message
    end
  end

  def test_create_session_with_unknown_profile
    VCR.use_cassette('session_test/test_create_session_with_unknown_profile', :allow_playback_repeats => true) do
      assert_raises EBSCO::EDS::BadRequest do
        EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-none'})
      end
    end
  end

  def test_create_session_failed_user_credentials
    VCR.use_cassette('session_test/profile_1/test_create_session_failed_user_credentials', :allow_playback_repeats => true) do
      assert_raises EBSCO::EDS::BadRequest do
        EBSCO::EDS::Session.new({
            use_cache: false,
            profile: 'eds-api',
            auth: 'user',
            user: 'fake',
            pass: 'none',
            guest: false,
            org: 'test'
                                })
      end
    end
  end

  def test_api_request_with_unsupported_method
    VCR.use_cassette('session_test/profile_1/test_api_request_with_unsupported_method', :allow_playback_repeats => true) do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      assert_raises EBSCO::EDS::ApiError do
        session.do_request(:put, path: 'testing')
      end
      session.end
    end
  end

  def test_api_request_beyond_max_attempt
    VCR.use_cassette('session_test/profile_1/test_api_request_beyond_max_attempt', :allow_playback_repeats => true) do
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      assert_raises EBSCO::EDS::ApiError do
        session.do_request(:get, path: 'testing', attempt: 5)
      end
      session.end
    end
  end

  def test_api_request_no_session_token_force_refresh
    VCR.use_cassette('session_test/profile_1/test_api_request_no_session_token_force_refresh', :allow_playback_repeats => true) do
      # should trigger 108
      session = EBSCO::EDS::Session.new({use_cache: false, profile: 'eds-api'})
      session.session_token = ''
      info = EBSCO::EDS::Info.new(session.do_request(:get, path: session.config[:info_url]))
      refute_nil info
      session.end
    end
  end

  def test_api_request_invalid_auth_token_force_refresh
    # should trigger 104 and too many attempts failure
    VCR.use_cassette('session_test/profile_1/test_api_request_invalid_auth_token_force_refresh', :allow_playback_repeats => true) do
      session = EBSCO::EDS::Session.new({
          use_cache: false,
          profile: 'eds-api',
          auth_token: 'bogus'
                                        })
      info = EBSCO::EDS::Info.new(session.do_request(:get, path: session.config[:info_url]))
      refute_nil info
      session.end
    end
  end

end