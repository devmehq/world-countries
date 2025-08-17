require 'spec_helper'

RSpec.describe WorldCountries::Countries do
  let(:countries) { WorldCountries::Countries.new }

  describe '#initialize' do
    it 'loads country data from JSON file' do
      expect(countries.countries).to be_an(Array)
      expect(countries.countries.size).to eq(250)
    end
  end

  describe '#all' do
    it 'returns all countries' do
      all_countries = countries.all
      expect(all_countries).to be_an(Array)
      expect(all_countries.size).to eq(250)
    end

    it 'returns countries with correct structure' do
      first_country = countries.all.first
      expect(first_country).to have_key('name')
      expect(first_country).to have_key('cca2')
      expect(first_country).to have_key('cca3')
      expect(first_country).to have_key('region')
      expect(first_country).to have_key('currencies')
    end
  end

  describe '#get_by_alpha2_code' do
    it 'returns country by alpha-2 code' do
      usa = countries.get_by_alpha2_code('US')
      expect(usa).not_to be_nil
      expect(usa['name']['common']).to eq('United States')
      expect(usa['cca2']).to eq('US')
    end

    it 'is case insensitive' do
      usa1 = countries.get_by_alpha2_code('us')
      usa2 = countries.get_by_alpha2_code('US')
      expect(usa1).to eq(usa2)
    end

    it 'returns nil for invalid code' do
      result = countries.get_by_alpha2_code('XX')
      expect(result).to be_nil
    end
  end

  describe '#get_by_alpha3_code' do
    it 'returns country by alpha-3 code' do
      usa = countries.get_by_alpha3_code('USA')
      expect(usa).not_to be_nil
      expect(usa['name']['common']).to eq('United States')
      expect(usa['cca3']).to eq('USA')
    end

    it 'returns nil for invalid code' do
      result = countries.get_by_alpha3_code('XXX')
      expect(result).to be_nil
    end
  end

  describe '#get_by_numeric_code' do
    it 'returns country by numeric code' do
      usa = countries.get_by_numeric_code('840')
      expect(usa).not_to be_nil
      expect(usa['name']['common']).to eq('United States')
      expect(usa['ccn3']).to eq('840')
    end

    it 'accepts integer input' do
      usa = countries.get_by_numeric_code(840)
      expect(usa).not_to be_nil
      expect(usa['ccn3']).to eq('840')
    end
  end

  describe '#get_by_common_name' do
    it 'returns country by common name' do
      france = countries.get_by_common_name('France')
      expect(france).not_to be_nil
      expect(france['cca2']).to eq('FR')
    end

    it 'is case insensitive' do
      france1 = countries.get_by_common_name('france')
      france2 = countries.get_by_common_name('FRANCE')
      expect(france1).to eq(france2)
    end
  end

  describe '#get_by_official_name' do
    it 'returns country by official name' do
      france = countries.get_by_official_name('French Republic')
      expect(france).not_to be_nil
      expect(france['cca2']).to eq('FR')
    end
  end

  describe '#get_by_region' do
    it 'returns countries by region' do
      european_countries = countries.get_by_region('Europe')
      expect(european_countries).not_to be_empty
      european_countries.each do |country|
        expect(country['region']).to eq('Europe')
      end
    end

    it 'returns empty array for invalid region' do
      result = countries.get_by_region('InvalidRegion')
      expect(result).to be_empty
    end
  end

  describe '#get_by_subregion' do
    it 'returns countries by subregion' do
      western_europe = countries.get_by_subregion('Western Europe')
      expect(western_europe).not_to be_empty
      western_europe.each do |country|
        expect(country['subregion']).to eq('Western Europe')
      end
    end
  end

  describe '#get_by_currency' do
    it 'returns countries using a specific currency' do
      euro_countries = countries.get_by_currency('EUR')
      expect(euro_countries).not_to be_empty
      euro_countries.each do |country|
        expect(country['currencies']).to have_key('EUR')
      end
    end

    it 'returns countries using USD' do
      usd_countries = countries.get_by_currency('USD')
      expect(usd_countries).not_to be_empty
      expect(usd_countries.any? { |c| c['name']['common'] == 'United States' }).to be true
    end
  end

  describe '#get_by_language' do
    it 'returns countries by language' do
      english_countries = countries.get_by_language('eng')
      expect(english_countries).not_to be_empty
      
      spanish_countries = countries.get_by_language('spa')
      expect(spanish_countries).not_to be_empty
    end
  end

  describe '#get_by_capital' do
    it 'returns countries by capital' do
      paris = countries.get_by_capital('Paris')
      expect(paris.size).to eq(1)
      expect(paris.first['name']['common']).to eq('France')
    end

    it 'is case insensitive' do
      london1 = countries.get_by_capital('london')
      london2 = countries.get_by_capital('LONDON')
      expect(london1).to eq(london2)
    end
  end

  describe '#get_by_continent' do
    it 'returns countries by continent' do
      african_countries = countries.get_by_continent('Africa')
      expect(african_countries).not_to be_empty
      african_countries.each do |country|
        expect(country['continents']).to include('Africa')
      end
    end
  end

  describe '#get_by_borders' do
    it 'returns countries bordering a specific country' do
      bordering_france = countries.get_by_borders('FRA')
      expect(bordering_france).not_to be_empty
      bordering_france.each do |country|
        expect(country['borders']).to include('FRA')
      end
    end
  end

  describe '#get_landlocked' do
    it 'returns only landlocked countries' do
      landlocked = countries.get_landlocked
      expect(landlocked).not_to be_empty
      landlocked.each do |country|
        expect(country['landlocked']).to be true
      end
    end
  end

  describe '#get_independent' do
    it 'returns only independent countries' do
      independent = countries.get_independent
      expect(independent).not_to be_empty
      independent.each do |country|
        expect(country['independent']).to be true
      end
    end
  end

  describe '#get_un_members' do
    it 'returns only UN member countries' do
      un_members = countries.get_un_members
      expect(un_members).not_to be_empty
      un_members.each do |country|
        expect(country['unMember']).to be true
      end
    end
  end

  describe '#search' do
    it 'searches countries by name' do
      results = countries.search('united')
      expect(results).not_to be_empty
      expect(results.any? { |c| c['name']['common'] == 'United States' }).to be true
      expect(results.any? { |c| c['name']['common'] == 'United Kingdom' }).to be true
    end

    it 'searches by country code' do
      results = countries.search('US')
      expect(results.any? { |c| c['cca2'] == 'US' }).to be true
    end

    it 'searches by capital' do
      results = countries.search('paris')
      expect(results.any? { |c| c['name']['common'] == 'France' }).to be true
    end
  end

  describe '#get_by_timezone' do
    it 'returns countries by timezone' do
      utc_countries = countries.get_by_timezone('UTC')
      expect(utc_countries).not_to be_empty
      utc_countries.each do |country|
        expect(country['timezones']).to include('UTC')
      end
    end
  end

  describe '#get_by_calling_code' do
    it 'returns countries by calling code' do
      countries_with_1 = countries.get_by_calling_code('1')
      expect(countries_with_1).not_to be_empty
    end
  end

  describe '#all_currencies' do
    it 'returns all unique currency codes' do
      currencies = countries.all_currencies
      expect(currencies).to be_an(Array)
      expect(currencies).not_to be_empty
      expect(currencies).to include('USD')
      expect(currencies).to include('EUR')
      expect(currencies).to eq(currencies.uniq) # Check uniqueness
    end
  end

  describe '#all_languages' do
    it 'returns all unique language codes' do
      languages = countries.all_languages
      expect(languages).to be_an(Array)
      expect(languages).not_to be_empty
      expect(languages).to eq(languages.uniq) # Check uniqueness
    end
  end

  describe '#all_capitals' do
    it 'returns all unique capitals' do
      capitals = countries.all_capitals
      expect(capitals).to be_an(Array)
      expect(capitals).not_to be_empty
      expect(capitals).to eq(capitals.uniq) # Check uniqueness
    end
  end

  describe '#all_regions' do
    it 'returns all unique regions' do
      regions = countries.all_regions
      expect(regions).to be_an(Array)
      expect(regions).not_to be_empty
      expect(regions).to include('Europe')
      expect(regions).to include('Asia')
    end
  end

  describe '#all_continents' do
    it 'returns all unique continents' do
      continents = countries.all_continents
      expect(continents).to be_an(Array)
      expect(continents.size).to eq(7) # 7 continents
    end
  end

  describe '#count' do
    it 'returns the total number of countries' do
      expect(countries.count).to eq(250)
    end
  end

  describe '#get_by_area' do
    it 'filters countries by minimum area' do
      large_countries = countries.get_by_area(min_area: 1_000_000)
      expect(large_countries).not_to be_empty
      large_countries.each do |country|
        expect(country['area']).to be >= 1_000_000
      end
    end

    it 'filters countries by area range' do
      medium_countries = countries.get_by_area(min_area: 100_000, max_area: 500_000)
      medium_countries.each do |country|
        expect(country['area']).to be >= 100_000
        expect(country['area']).to be <= 500_000
      end
    end
  end

  describe '#get_by_population' do
    it 'filters countries by minimum population' do
      populous_countries = countries.get_by_population(min_pop: 100_000_000)
      expect(populous_countries).not_to be_empty
      populous_countries.each do |country|
        expect(country['population']).to be >= 100_000_000
      end
    end

    it 'filters countries by population range' do
      mid_size_countries = countries.get_by_population(min_pop: 10_000_000, max_pop: 50_000_000)
      mid_size_countries.each do |country|
        expect(country['population']).to be >= 10_000_000
        expect(country['population']).to be <= 50_000_000
      end
    end
  end

  describe '#sort_by_name' do
    it 'sorts countries by name in ascending order' do
      sorted = countries.sort_by_name(order: 'asc')
      expect(sorted.first['name']['common'] < sorted.last['name']['common']).to be true
      
      sorted.each_cons(2) do |a, b|
        expect(a['name']['common'] <= b['name']['common']).to be true
      end
    end

    it 'sorts countries by name in descending order' do
      sorted = countries.sort_by_name(order: 'desc')
      expect(sorted.first['name']['common'] > sorted.last['name']['common']).to be true
    end
  end

  describe '#sort_by_population' do
    it 'sorts countries by population in descending order by default' do
      sorted = countries.sort_by_population
      expect(sorted.first['population'] >= sorted.last['population']).to be true
    end

    it 'sorts countries by population in ascending order' do
      sorted = countries.sort_by_population(order: 'asc')
      expect(sorted.first['population'] <= sorted.last['population']).to be true
    end
  end

  describe '#sort_by_area' do
    it 'sorts countries by area in descending order by default' do
      sorted = countries.sort_by_area
      expect(sorted.first['area'] >= sorted.last['area']).to be true
    end

    it 'sorts countries by area in ascending order' do
      sorted = countries.sort_by_area(order: 'asc')
      expect(sorted.first['area'] <= sorted.last['area']).to be true
    end
  end
end