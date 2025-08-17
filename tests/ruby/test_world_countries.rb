#!/usr/bin/env ruby

# Simple test runner for WorldCountries Ruby implementation
# This doesn't require RSpec to be installed

$LOAD_PATH.unshift File.expand_path('../../src/ruby', __dir__)
require 'world_countries'

class TestWorldCountries
  def initialize
    @countries = WorldCountries::Countries.new
    @passed = 0
    @failed = 0
  end

  def assert(condition, message)
    if condition
      @passed += 1
      print "."
    else
      @failed += 1
      print "F"
      puts "\n  FAILED: #{message}"
    end
  end

  def assert_equal(expected, actual, message)
    assert(expected == actual, "#{message} - Expected: #{expected}, Got: #{actual}")
  end

  def assert_not_nil(value, message)
    assert(!value.nil?, "#{message} - Expected not nil, but got nil")
  end

  def assert_includes(array, value, message)
    assert(array.include?(value), "#{message} - Expected #{array} to include #{value}")
  end

  def run_tests
    puts "Running WorldCountries Ruby Tests..."
    puts "=" * 50

    # Test initialization
    assert(@countries.countries.is_a?(Array), "Countries should be an array")
    assert_equal(250, @countries.count, "Should have 250 countries")

    # Test get_by_alpha2_code
    usa = @countries.get_by_alpha2_code('US')
    assert_not_nil(usa, "Should find USA by alpha2 code")
    assert_equal('United States', usa['name']['common'], "USA common name") if usa

    # Test case insensitivity
    usa_lower = @countries.get_by_alpha2_code('us')
    assert_equal(usa, usa_lower, "Alpha2 code should be case insensitive")

    # Test invalid code
    invalid = @countries.get_by_alpha2_code('XX')
    assert(invalid.nil?, "Should return nil for invalid code")

    # Test get_by_alpha3_code
    usa3 = @countries.get_by_alpha3_code('USA')
    assert_not_nil(usa3, "Should find USA by alpha3 code")
    assert_equal('USA', usa3['cca3'], "USA alpha3 code") if usa3

    # Test get_by_common_name
    france = @countries.get_by_common_name('France')
    assert_not_nil(france, "Should find France by common name")
    assert_equal('FR', france['cca2'], "France alpha2 code") if france

    # Test get_by_region
    european = @countries.get_by_region('Europe')
    assert(european.length > 0, "Should have European countries")
    assert(european.all? { |c| c['region'] == 'Europe' }, "All should be in Europe")

    # Test get_by_currency
    euro_countries = @countries.get_by_currency('EUR')
    assert(euro_countries.length > 0, "Should have countries using EUR")
    assert(euro_countries.all? { |c| c['currencies'].key?('EUR') }, "All should use EUR")

    # Test get_by_language
    english_countries = @countries.get_by_language('eng')
    assert(english_countries.length > 0, "Should have English-speaking countries")

    # Test get_by_capital
    paris = @countries.get_by_capital('Paris')
    assert_equal(1, paris.length, "Should find one country with capital Paris")
    assert_equal('France', paris.first['name']['common'], "Paris is capital of France") if paris.first

    # Test get_landlocked
    landlocked = @countries.get_landlocked
    assert(landlocked.length > 0, "Should have landlocked countries")
    assert(landlocked.all? { |c| c['landlocked'] == true }, "All should be landlocked")

    # Test get_independent
    independent = @countries.get_independent
    assert(independent.length > 0, "Should have independent countries")
    assert(independent.all? { |c| c['independent'] == true }, "All should be independent")

    # Test search
    united = @countries.search('united')
    assert(united.length > 0, "Should find countries with 'united' in name")
    assert(united.any? { |c| c['name']['common'] == 'United States' }, "Should include United States")

    # Test all_currencies
    currencies = @countries.all_currencies
    assert(currencies.is_a?(Array), "Currencies should be an array")
    assert_includes(currencies, 'USD', "Should include USD")
    assert_includes(currencies, 'EUR', "Should include EUR")

    # Test all_regions
    regions = @countries.all_regions
    assert(regions.is_a?(Array), "Regions should be an array")
    assert_includes(regions, 'Europe', "Should include Europe")
    assert_includes(regions, 'Asia', "Should include Asia")

    # Test all_continents
    continents = @countries.all_continents
    assert(continents.is_a?(Array), "Continents should be an array")
    assert_equal(7, continents.length, "Should have 7 continents")

    # Test sort_by_name
    sorted = @countries.sort_by_name(order: 'asc')
    assert(sorted.first['name']['common'] < sorted.last['name']['common'], "Should be sorted ascending")

    # Test get_by_area
    large = @countries.get_by_area(min_area: 1_000_000)
    assert(large.length > 0, "Should have large countries")
    assert(large.all? { |c| c['area'] >= 1_000_000 }, "All should have area >= 1,000,000")

    # Test get_by_population
    populous = @countries.get_by_population(min_pop: 100_000_000)
    assert(populous.length > 0, "Should have populous countries")
    assert(populous.all? { |c| c['population'] >= 100_000_000 }, "All should have pop >= 100M")

    puts "\n" + "=" * 50
    puts "Test Results:"
    puts "  Passed: #{@passed}"
    puts "  Failed: #{@failed}"
    puts "  Total:  #{@passed + @failed}"
    puts "=" * 50
    
    if @failed == 0
      puts "✅ All tests passed!"
      exit(0)
    else
      puts "❌ #{@failed} tests failed"
      exit(1)
    end
  end
end

# Run the tests
if __FILE__ == $0
  tester = TestWorldCountries.new
  tester.run_tests
end