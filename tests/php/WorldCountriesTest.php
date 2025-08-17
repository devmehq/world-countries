<?php

namespace DevMe\WorldCountries\Tests;

use DevMe\WorldCountries\WorldCountries;
use PHPUnit\Framework\TestCase;

class WorldCountriesTest extends TestCase
{
    private WorldCountries $worldCountries;

    protected function setUp(): void
    {
        $this->worldCountries = new WorldCountries();
    }

    public function testGetAll(): void
    {
        $countries = $this->worldCountries->getAll();
        
        $this->assertIsArray($countries);
        $this->assertCount(250, $countries);
        
        // Check structure of first country
        $firstCountry = reset($countries);
        $this->assertArrayHasKey('name', $firstCountry);
        $this->assertArrayHasKey('cca2', $firstCountry);
        $this->assertArrayHasKey('cca3', $firstCountry);
        $this->assertArrayHasKey('region', $firstCountry);
        $this->assertArrayHasKey('currencies', $firstCountry);
    }

    public function testGetByAlpha2Code(): void
    {
        $usa = $this->worldCountries->getByAlpha2Code('US');
        
        $this->assertNotNull($usa);
        $this->assertEquals('United States', $usa['name']['common']);
        $this->assertEquals('US', $usa['cca2']);
        
        // Test case insensitivity
        $usaLower = $this->worldCountries->getByAlpha2Code('us');
        $this->assertEquals($usa, $usaLower);
        
        // Test invalid code
        $invalid = $this->worldCountries->getByAlpha2Code('XX');
        $this->assertNull($invalid);
    }

    public function testGetByAlpha3Code(): void
    {
        $usa = $this->worldCountries->getByAlpha3Code('USA');
        
        $this->assertNotNull($usa);
        $this->assertEquals('United States', $usa['name']['common']);
        $this->assertEquals('USA', $usa['cca3']);
        
        // Test invalid code
        $invalid = $this->worldCountries->getByAlpha3Code('XXX');
        $this->assertNull($invalid);
    }

    public function testGetByNumericCode(): void
    {
        $usa = $this->worldCountries->getByNumericCode('840');
        
        $this->assertNotNull($usa);
        $this->assertEquals('United States', $usa['name']['common']);
        $this->assertEquals('840', $usa['ccn3']);
    }

    public function testGetByCommonName(): void
    {
        $france = $this->worldCountries->getByCommonName('France');
        
        $this->assertNotNull($france);
        $this->assertEquals('FR', $france['cca2']);
        
        // Test case insensitivity
        $franceLower = $this->worldCountries->getByCommonName('france');
        $this->assertEquals($france, $franceLower);
    }

    public function testGetByOfficialName(): void
    {
        $france = $this->worldCountries->getByOfficialName('French Republic');
        
        $this->assertNotNull($france);
        $this->assertEquals('FR', $france['cca2']);
    }

    public function testGetByRegion(): void
    {
        $europeanCountries = $this->worldCountries->getByRegion('Europe');
        
        $this->assertNotEmpty($europeanCountries);
        foreach ($europeanCountries as $country) {
            $this->assertEquals('Europe', $country['region']);
        }
        
        // Test empty result
        $invalid = $this->worldCountries->getByRegion('InvalidRegion');
        $this->assertEmpty($invalid);
    }

    public function testGetBySubregion(): void
    {
        $westernEurope = $this->worldCountries->getBySubregion('Western Europe');
        
        $this->assertNotEmpty($westernEurope);
        foreach ($westernEurope as $country) {
            $this->assertEquals('Western Europe', $country['subregion']);
        }
    }

    public function testGetByCurrency(): void
    {
        $euroCountries = $this->worldCountries->getByCurrency('EUR');
        
        $this->assertNotEmpty($euroCountries);
        foreach ($euroCountries as $country) {
            $this->assertArrayHasKey('EUR', $country['currencies']);
        }
        
        // Test USD
        $usdCountries = $this->worldCountries->getByCurrency('USD');
        $this->assertNotEmpty($usdCountries);
        
        $hasUSA = false;
        foreach ($usdCountries as $country) {
            if ($country['name']['common'] === 'United States') {
                $hasUSA = true;
                break;
            }
        }
        $this->assertTrue($hasUSA);
    }

    public function testGetByLanguage(): void
    {
        $englishCountries = $this->worldCountries->getByLanguage('eng');
        $this->assertNotEmpty($englishCountries);
        
        $spanishCountries = $this->worldCountries->getByLanguage('spa');
        $this->assertNotEmpty($spanishCountries);
    }

    public function testGetByCapital(): void
    {
        $paris = $this->worldCountries->getByCapital('Paris');
        
        $this->assertCount(1, $paris);
        $this->assertEquals('France', $paris[0]['name']['common']);
        
        // Test case insensitivity
        $london1 = $this->worldCountries->getByCapital('london');
        $london2 = $this->worldCountries->getByCapital('LONDON');
        $this->assertEquals($london1, $london2);
    }

    public function testGetByContinent(): void
    {
        $africanCountries = $this->worldCountries->getByContinent('Africa');
        
        $this->assertNotEmpty($africanCountries);
        foreach ($africanCountries as $country) {
            $this->assertContains('Africa', $country['continents']);
        }
    }

    public function testGetByBorders(): void
    {
        $borderingFrance = $this->worldCountries->getByBorders('FRA');
        
        $this->assertNotEmpty($borderingFrance);
        foreach ($borderingFrance as $country) {
            $this->assertContains('FRA', $country['borders']);
        }
    }

    public function testGetLandlocked(): void
    {
        $landlocked = $this->worldCountries->getLandlocked();
        
        $this->assertNotEmpty($landlocked);
        foreach ($landlocked as $country) {
            $this->assertTrue($country['landlocked']);
        }
    }

    public function testGetIndependent(): void
    {
        $independent = $this->worldCountries->getIndependent();
        
        $this->assertNotEmpty($independent);
        foreach ($independent as $country) {
            $this->assertTrue($country['independent']);
        }
    }

    public function testGetUNMembers(): void
    {
        $unMembers = $this->worldCountries->getUNMembers();
        
        $this->assertNotEmpty($unMembers);
        foreach ($unMembers as $country) {
            $this->assertTrue($country['unMember']);
        }
    }

    public function testSearch(): void
    {
        $results = $this->worldCountries->search('united');
        
        $this->assertNotEmpty($results);
        
        $hasUS = false;
        $hasUK = false;
        foreach ($results as $country) {
            if ($country['name']['common'] === 'United States') {
                $hasUS = true;
            }
            if ($country['name']['common'] === 'United Kingdom') {
                $hasUK = true;
            }
        }
        
        $this->assertTrue($hasUS);
        $this->assertTrue($hasUK);
        
        // Test search by code
        $usResults = $this->worldCountries->search('US');
        $hasUSCode = false;
        foreach ($usResults as $country) {
            if ($country['cca2'] === 'US') {
                $hasUSCode = true;
                break;
            }
        }
        $this->assertTrue($hasUSCode);
    }

    public function testGetByTimezone(): void
    {
        $utcCountries = $this->worldCountries->getByTimezone('UTC');
        
        $this->assertNotEmpty($utcCountries);
        foreach ($utcCountries as $country) {
            $this->assertContains('UTC', $country['timezones']);
        }
    }

    public function testGetByCallingCode(): void
    {
        $countries = $this->worldCountries->getByCallingCode('1');
        
        $this->assertNotEmpty($countries);
    }

    public function testGetAllCurrencies(): void
    {
        $currencies = $this->worldCountries->getAllCurrencies();
        
        $this->assertIsArray($currencies);
        $this->assertNotEmpty($currencies);
        $this->assertContains('USD', $currencies);
        $this->assertContains('EUR', $currencies);
        
        // Check uniqueness
        $this->assertEquals($currencies, array_unique($currencies));
    }

    public function testGetAllLanguages(): void
    {
        $languages = $this->worldCountries->getAllLanguages();
        
        $this->assertIsArray($languages);
        $this->assertNotEmpty($languages);
        
        // Check uniqueness
        $this->assertEquals($languages, array_unique($languages));
    }

    public function testGetAllCapitals(): void
    {
        $capitals = $this->worldCountries->getAllCapitals();
        
        $this->assertIsArray($capitals);
        $this->assertNotEmpty($capitals);
        
        // Check uniqueness
        $this->assertEquals($capitals, array_unique($capitals));
    }

    public function testGetAllRegions(): void
    {
        $regions = $this->worldCountries->getAllRegions();
        
        $this->assertIsArray($regions);
        $this->assertNotEmpty($regions);
        $this->assertContains('Europe', $regions);
        $this->assertContains('Asia', $regions);
    }

    public function testGetAllSubregions(): void
    {
        $subregions = $this->worldCountries->getAllSubregions();
        
        $this->assertIsArray($subregions);
        $this->assertNotEmpty($subregions);
    }

    public function testGetAllContinents(): void
    {
        $continents = $this->worldCountries->getAllContinents();
        
        $this->assertIsArray($continents);
        $this->assertCount(7, $continents); // 7 continents
    }

    public function testGetAllTimezones(): void
    {
        $timezones = $this->worldCountries->getAllTimezones();
        
        $this->assertIsArray($timezones);
        $this->assertNotEmpty($timezones);
    }

    public function testCount(): void
    {
        $count = $this->worldCountries->count();
        
        $this->assertEquals(250, $count);
    }

    public function testGetByArea(): void
    {
        // Test minimum area
        $largeCountries = $this->worldCountries->getByArea(1000000);
        $this->assertNotEmpty($largeCountries);
        foreach ($largeCountries as $country) {
            $this->assertGreaterThanOrEqual(1000000, $country['area']);
        }
        
        // Test area range
        $mediumCountries = $this->worldCountries->getByArea(100000, 500000);
        foreach ($mediumCountries as $country) {
            $this->assertGreaterThanOrEqual(100000, $country['area']);
            $this->assertLessThanOrEqual(500000, $country['area']);
        }
    }

    public function testGetByPopulation(): void
    {
        // Test minimum population
        $populousCountries = $this->worldCountries->getByPopulation(100000000);
        $this->assertNotEmpty($populousCountries);
        foreach ($populousCountries as $country) {
            $this->assertGreaterThanOrEqual(100000000, $country['population']);
        }
        
        // Test population range
        $midSizeCountries = $this->worldCountries->getByPopulation(10000000, 50000000);
        foreach ($midSizeCountries as $country) {
            $this->assertGreaterThanOrEqual(10000000, $country['population']);
            $this->assertLessThanOrEqual(50000000, $country['population']);
        }
    }

    public function testSortByName(): void
    {
        // Test ascending sort
        $sortedAsc = $this->worldCountries->sortByName('asc');
        $this->assertNotEmpty($sortedAsc);
        
        $prev = '';
        foreach ($sortedAsc as $country) {
            if ($prev !== '') {
                $this->assertGreaterThanOrEqual(0, strcmp($prev, $country['name']['common']));
            }
            $prev = $country['name']['common'];
        }
        
        // Test descending sort
        $sortedDesc = $this->worldCountries->sortByName('desc');
        $this->assertNotEmpty($sortedDesc);
        
        $prev = 'ZZZZZ';
        foreach ($sortedDesc as $country) {
            if ($prev !== 'ZZZZZ') {
                $this->assertLessThanOrEqual(0, strcmp($prev, $country['name']['common']));
            }
            $prev = $country['name']['common'];
        }
    }

    public function testSortByPopulation(): void
    {
        // Test default descending sort
        $sorted = $this->worldCountries->sortByPopulation();
        $this->assertNotEmpty($sorted);
        
        $prev = PHP_INT_MAX;
        foreach ($sorted as $country) {
            $this->assertLessThanOrEqual($prev, $country['population']);
            $prev = $country['population'];
        }
        
        // Test ascending sort
        $sortedAsc = $this->worldCountries->sortByPopulation('asc');
        $prev = 0;
        foreach ($sortedAsc as $country) {
            $this->assertGreaterThanOrEqual($prev, $country['population']);
            $prev = $country['population'];
        }
    }

    public function testSortByArea(): void
    {
        // Test default descending sort
        $sorted = $this->worldCountries->sortByArea();
        $this->assertNotEmpty($sorted);
        
        $prev = PHP_INT_MAX;
        foreach ($sorted as $country) {
            $this->assertLessThanOrEqual($prev, $country['area']);
            $prev = $country['area'];
        }
        
        // Test ascending sort
        $sortedAsc = $this->worldCountries->sortByArea('asc');
        $prev = 0;
        foreach ($sortedAsc as $country) {
            $this->assertGreaterThanOrEqual($prev, $country['area']);
            $prev = $country['area'];
        }
    }
}