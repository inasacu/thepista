require 'test/unit'
require 'ayah_integration'

class AYAHIntegrationTest < Test::Unit::TestCase
  
  def setup
    @pub_key = 'get_your_own_pub_key'
    @score_key = 'get_this_with_the_pub_key'
    @session_secret = 'shhhhhhhhhh'
    @ayah = AYAH::Integration.new(@pub_key, @score_key)
  end
  
  def test_get_publisher_html
    assert_equal((@ayah.get_publisher_html.size > 0), true)
  end

  def test_score_result_for_neg_ten
    result = @ayah.score_result(@session_secret, '127.0.0.1')
    assert_equal(-100, @ayah.__score_result_status_code)
    assert_equal(false, @ayah.passed)
  end
  
  def test_record_conversion
    assert_equal((@ayah.record_conversion('invalid_session_secret').size > 0), true)
    assert_equal(@ayah.converted, true)
  end

end