import pytest
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../src/python'))

from world_countries import WorldCountries


class TestWorldCountries:
    @pytest.fixture(autouse=True)
    def setup(self):
        self.countries = WorldCountries()

    def test_get_all(self):
        all_countries = self.countries.get_all()
        assert isinstance(all_countries, list)
        assert len(all_countries) == 250
        
        # Check structure of first country
        first_country = all_countries[0]
        assert 'name' in first_country
        assert 'cca2' in first_country
        assert 'cca3' in first_country
        assert 'region' in first_country
        assert 'currencies' in first_country

    def test_get_by_alpha2_code(self):
        usa = self.countries.get_by_alpha2_code('US')
        assert usa is not None
        assert usa['name']['common'] == 'United States'
        assert usa['cca2'] == 'US'
        
        # Test case insensitivity
        usa_lower = self.countries.get_by_alpha2_code('us')
        assert usa == usa_lower
        
        # Test invalid code
        invalid = self.countries.get_by_alpha2_code('XX')
        assert invalid is None

    def test_get_by_alpha3_code(self):
        usa = self.countries.get_by_alpha3_code('USA')
        assert usa is not None
        assert usa['name']['common'] == 'United States'
        assert usa['cca3'] == 'USA'
        
        # Test invalid code
        invalid = self.countries.get_by_alpha3_code('XXX')
        assert invalid is None

    def test_get_by_numeric_code(self):
        usa = self.countries.get_by_numeric_code('840')
        assert usa is not None
        assert usa['name']['common'] == 'United States'
        assert usa['ccn3'] == '840'

    def test_get_by_common_name(self):
        france = self.countries.get_by_common_name('France')
        assert france is not None
        assert france['cca2'] == 'FR'
        
        # Test case insensitivity
        france_lower = self.countries.get_by_common_name('france')
        assert france == france_lower

    def test_get_by_official_name(self):
        france = self.countries.get_by_official_name('French Republic')
        assert france is not None
        assert france['cca2'] == 'FR'

    def test_get_by_region(self):
        european_countries = self.countries.get_by_region('Europe')
        assert len(european_countries) > 0
        for country in european_countries:
            assert country['region'] == 'Europe'
        
        # Test empty result
        invalid = self.countries.get_by_region('InvalidRegion')
        assert invalid == []

    def test_get_by_subregion(self):
        western_europe = self.countries.get_by_subregion('Western Europe')
        assert len(western_europe) > 0
        for country in western_europe:
            assert country['subregion'] == 'Western Europe'

    def test_get_by_currency(self):
        euro_countries = self.countries.get_by_currency('EUR')
        assert len(euro_countries) > 0
        for country in euro_countries:
            assert 'EUR' in country['currencies']
        
        # Test USD
        usd_countries = self.countries.get_by_currency('USD')
        assert len(usd_countries) > 0
        assert any(c['name']['common'] == 'United States' for c in usd_countries)

    def test_get_by_language(self):
        english_countries = self.countries.get_by_language('eng')
        assert len(english_countries) > 0
        
        spanish_countries = self.countries.get_by_language('spa')
        assert len(spanish_countries) > 0

    def test_get_by_capital(self):
        paris = self.countries.get_by_capital('Paris')
        assert len(paris) == 1
        assert paris[0]['name']['common'] == 'France'
        
        # Test case insensitivity
        london1 = self.countries.get_by_capital('london')
        london2 = self.countries.get_by_capital('LONDON')
        assert london1 == london2

    def test_get_by_continent(self):
        african_countries = self.countries.get_by_continent('Africa')
        assert len(african_countries) > 0
        for country in african_countries:
            assert 'Africa' in country['continents']

    def test_get_by_borders(self):
        bordering_france = self.countries.get_by_borders('FRA')
        assert len(bordering_france) > 0
        for country in bordering_france:
            assert 'FRA' in country['borders']

    def test_get_landlocked(self):
        landlocked = self.countries.get_landlocked()
        assert len(landlocked) > 0
        for country in landlocked:
            assert country['landlocked'] is True

    def test_get_independent(self):
        independent = self.countries.get_independent()
        assert len(independent) > 0
        for country in independent:
            assert country['independent'] is True

    def test_get_un_members(self):
        un_members = self.countries.get_un_members()
        assert len(un_members) > 0
        for country in un_members:
            assert country['unMember'] is True

    def test_search(self):
        results = self.countries.search('united')
        assert len(results) > 0
        assert any(c['name']['common'] == 'United States' for c in results)
        assert any(c['name']['common'] == 'United Kingdom' for c in results)
        
        # Test search by code
        us_results = self.countries.search('US')
        assert any(c['cca2'] == 'US' for c in us_results)
        
        # Test search by capital
        paris_results = self.countries.search('paris')
        assert any(c['name']['common'] == 'France' for c in paris_results)

    def test_get_by_timezone(self):
        utc_countries = self.countries.get_by_timezone('UTC')
        assert len(utc_countries) > 0
        for country in utc_countries:
            assert 'UTC' in country['timezones']

    def test_get_by_calling_code(self):
        countries_with_1 = self.countries.get_by_calling_code('1')
        assert len(countries_with_1) > 0

    def test_get_all_currencies(self):
        currencies = self.countries.get_all_currencies()
        assert isinstance(currencies, list)
        assert len(currencies) > 0
        assert 'USD' in currencies
        assert 'EUR' in currencies
        # Check uniqueness
        assert currencies == sorted(list(set(currencies)))

    def test_get_all_languages(self):
        languages = self.countries.get_all_languages()
        assert isinstance(languages, list)
        assert len(languages) > 0
        # Check uniqueness
        assert languages == sorted(list(set(languages)))

    def test_get_all_capitals(self):
        capitals = self.countries.get_all_capitals()
        assert isinstance(capitals, list)
        assert len(capitals) > 0
        # Check uniqueness
        assert capitals == sorted(list(set(capitals)))

    def test_get_all_regions(self):
        regions = self.countries.get_all_regions()
        assert isinstance(regions, list)
        assert len(regions) > 0
        assert 'Europe' in regions
        assert 'Asia' in regions

    def test_get_all_subregions(self):
        subregions = self.countries.get_all_subregions()
        assert isinstance(subregions, list)
        assert len(subregions) > 0

    def test_get_all_continents(self):
        continents = self.countries.get_all_continents()
        assert isinstance(continents, list)
        assert len(continents) == 7  # 7 continents

    def test_get_all_timezones(self):
        timezones = self.countries.get_all_timezones()
        assert isinstance(timezones, list)
        assert len(timezones) > 0

    def test_count(self):
        count = self.countries.count()
        assert count == 250

    def test_get_by_area(self):
        # Test minimum area
        large_countries = self.countries.get_by_area(min_area=1000000)
        assert len(large_countries) > 0
        for country in large_countries:
            assert country['area'] >= 1000000
        
        # Test area range
        medium_countries = self.countries.get_by_area(min_area=100000, max_area=500000)
        for country in medium_countries:
            assert 100000 <= country['area'] <= 500000

    def test_get_by_population(self):
        # Test minimum population
        populous_countries = self.countries.get_by_population(min_pop=100000000)
        assert len(populous_countries) > 0
        for country in populous_countries:
            assert country['population'] >= 100000000
        
        # Test population range
        mid_size_countries = self.countries.get_by_population(min_pop=10000000, max_pop=50000000)
        for country in mid_size_countries:
            assert 10000000 <= country['population'] <= 50000000

    def test_sort_by_name(self):
        # Test ascending sort
        sorted_asc = self.countries.sort_by_name('asc')
        assert len(sorted_asc) > 0
        for i in range(1, len(sorted_asc)):
            assert sorted_asc[i-1]['name']['common'] <= sorted_asc[i]['name']['common']
        
        # Test descending sort
        sorted_desc = self.countries.sort_by_name('desc')
        assert len(sorted_desc) > 0
        for i in range(1, len(sorted_desc)):
            assert sorted_desc[i-1]['name']['common'] >= sorted_desc[i]['name']['common']

    def test_sort_by_population(self):
        # Test default descending sort
        sorted_desc = self.countries.sort_by_population()
        assert len(sorted_desc) > 0
        for i in range(1, len(sorted_desc)):
            assert sorted_desc[i-1]['population'] >= sorted_desc[i]['population']
        
        # Test ascending sort
        sorted_asc = self.countries.sort_by_population('asc')
        for i in range(1, len(sorted_asc)):
            assert sorted_asc[i-1]['population'] <= sorted_asc[i]['population']

    def test_sort_by_area(self):
        # Test default descending sort
        sorted_desc = self.countries.sort_by_area()
        assert len(sorted_desc) > 0
        for i in range(1, len(sorted_desc)):
            assert sorted_desc[i-1]['area'] >= sorted_desc[i]['area']
        
        # Test ascending sort
        sorted_asc = self.countries.sort_by_area('asc')
        for i in range(1, len(sorted_asc)):
            assert sorted_asc[i-1]['area'] <= sorted_asc[i]['area']