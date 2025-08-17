import { WorldCountries } from '../../src/typescript';

describe('WorldCountries', () => {
  let worldCountries: WorldCountries;

  beforeEach(() => {
    worldCountries = new WorldCountries();
  });

  describe('getAll', () => {
    it('should return all countries', () => {
      const countries = worldCountries.getAll();
      expect(countries).toHaveLength(250);
      expect(Array.isArray(countries)).toBe(true);
    });

    it('should return countries with correct structure', () => {
      const countries = worldCountries.getAll();
      const firstCountry = countries[0];
      
      expect(firstCountry).toHaveProperty('name');
      expect(firstCountry).toHaveProperty('cca2');
      expect(firstCountry).toHaveProperty('cca3');
      expect(firstCountry).toHaveProperty('region');
      expect(firstCountry).toHaveProperty('currencies');
    });
  });

  describe('getByAlpha2Code', () => {
    it('should return country by alpha-2 code', () => {
      const usa = worldCountries.getByAlpha2Code('US');
      expect(usa).toBeDefined();
      expect(usa?.name.common).toBe('United States');
      expect(usa?.cca2).toBe('US');
    });

    it('should be case insensitive', () => {
      const usa1 = worldCountries.getByAlpha2Code('us');
      const usa2 = worldCountries.getByAlpha2Code('US');
      expect(usa1).toEqual(usa2);
    });

    it('should return undefined for invalid code', () => {
      const result = worldCountries.getByAlpha2Code('XX');
      expect(result).toBeUndefined();
    });
  });

  describe('getByAlpha3Code', () => {
    it('should return country by alpha-3 code', () => {
      const usa = worldCountries.getByAlpha3Code('USA');
      expect(usa).toBeDefined();
      expect(usa?.name.common).toBe('United States');
      expect(usa?.cca3).toBe('USA');
    });

    it('should return undefined for invalid code', () => {
      const result = worldCountries.getByAlpha3Code('XXX');
      expect(result).toBeUndefined();
    });
  });

  describe('getByCommonName', () => {
    it('should return country by common name', () => {
      const france = worldCountries.getByCommonName('France');
      expect(france).toBeDefined();
      expect(france?.cca2).toBe('FR');
    });

    it('should be case insensitive', () => {
      const france1 = worldCountries.getByCommonName('france');
      const france2 = worldCountries.getByCommonName('FRANCE');
      expect(france1).toEqual(france2);
    });
  });

  describe('getByRegion', () => {
    it('should return countries by region', () => {
      const europeanCountries = worldCountries.getByRegion('Europe');
      expect(europeanCountries.length).toBeGreaterThan(0);
      expect(europeanCountries.every(c => c.region === 'Europe')).toBe(true);
    });

    it('should return empty array for invalid region', () => {
      const result = worldCountries.getByRegion('InvalidRegion');
      expect(result).toEqual([]);
    });
  });

  describe('getBySubregion', () => {
    it('should return countries by subregion', () => {
      const westernEurope = worldCountries.getBySubregion('Western Europe');
      expect(westernEurope.length).toBeGreaterThan(0);
      expect(westernEurope.every(c => c.subregion === 'Western Europe')).toBe(true);
    });
  });

  describe('getByCurrency', () => {
    it('should return countries using a specific currency', () => {
      const euroCountries = worldCountries.getByCurrency('EUR');
      expect(euroCountries.length).toBeGreaterThan(0);
      expect(euroCountries.every(c => 'EUR' in c.currencies)).toBe(true);
    });

    it('should return countries using USD', () => {
      const usdCountries = worldCountries.getByCurrency('USD');
      expect(usdCountries.length).toBeGreaterThan(0);
      expect(usdCountries.some(c => c.name.common === 'United States')).toBe(true);
    });
  });

  describe('getByLanguage', () => {
    it('should return countries by language', () => {
      const englishCountries = worldCountries.getByLanguage('eng');
      expect(englishCountries.length).toBeGreaterThan(0);
      
      const spanishCountries = worldCountries.getByLanguage('spa');
      expect(spanishCountries.length).toBeGreaterThan(0);
    });
  });

  describe('getByCapital', () => {
    it('should return countries by capital', () => {
      const paris = worldCountries.getByCapital('Paris');
      expect(paris.length).toBe(1);
      expect(paris[0].name.common).toBe('France');
    });

    it('should be case insensitive', () => {
      const london1 = worldCountries.getByCapital('london');
      const london2 = worldCountries.getByCapital('LONDON');
      expect(london1).toEqual(london2);
    });
  });

  describe('getByContinent', () => {
    it('should return countries by continent', () => {
      const africanCountries = worldCountries.getByContinent('Africa');
      expect(africanCountries.length).toBeGreaterThan(0);
      expect(africanCountries.every(c => c.continents.includes('Africa'))).toBe(true);
    });
  });

  describe('getLandlocked', () => {
    it('should return only landlocked countries', () => {
      const landlocked = worldCountries.getLandlocked();
      expect(landlocked.length).toBeGreaterThan(0);
      expect(landlocked.every(c => c.landlocked === true)).toBe(true);
    });
  });

  describe('getIndependent', () => {
    it('should return only independent countries', () => {
      const independent = worldCountries.getIndependent();
      expect(independent.length).toBeGreaterThan(0);
      expect(independent.every(c => c.independent === true)).toBe(true);
    });
  });

  describe('getUNMembers', () => {
    it('should return only UN member countries', () => {
      const unMembers = worldCountries.getUNMembers();
      expect(unMembers.length).toBeGreaterThan(0);
      expect(unMembers.every(c => c.unMember === true)).toBe(true);
    });
  });

  describe('search', () => {
    it('should search countries by name', () => {
      const results = worldCountries.search('united');
      expect(results.length).toBeGreaterThan(0);
      expect(results.some(c => c.name.common === 'United States')).toBe(true);
      expect(results.some(c => c.name.common === 'United Kingdom')).toBe(true);
    });

    it('should search by country code', () => {
      const results = worldCountries.search('US');
      expect(results.some(c => c.cca2 === 'US')).toBe(true);
    });

    it('should search by capital', () => {
      const results = worldCountries.search('paris');
      expect(results.some(c => c.name.common === 'France')).toBe(true);
    });
  });

  describe('getByTimezone', () => {
    it('should return countries by timezone', () => {
      const utcCountries = worldCountries.getByTimezone('UTC');
      expect(utcCountries.length).toBeGreaterThan(0);
    });
  });

  describe('getAllCurrencies', () => {
    it('should return all unique currency codes', () => {
      const currencies = worldCountries.getAllCurrencies();
      expect(Array.isArray(currencies)).toBe(true);
      expect(currencies.length).toBeGreaterThan(0);
      expect(currencies.includes('USD')).toBe(true);
      expect(currencies.includes('EUR')).toBe(true);
      expect(currencies).toEqual([...new Set(currencies)]); // Check uniqueness
    });
  });

  describe('getAllLanguages', () => {
    it('should return all unique language codes', () => {
      const languages = worldCountries.getAllLanguages();
      expect(Array.isArray(languages)).toBe(true);
      expect(languages.length).toBeGreaterThan(0);
      expect(languages).toEqual([...new Set(languages)]); // Check uniqueness
    });
  });

  describe('getAllCapitals', () => {
    it('should return all unique capitals', () => {
      const capitals = worldCountries.getAllCapitals();
      expect(Array.isArray(capitals)).toBe(true);
      expect(capitals.length).toBeGreaterThan(0);
      expect(capitals).toEqual([...new Set(capitals)]); // Check uniqueness
    });
  });

  describe('getAllRegions', () => {
    it('should return all unique regions', () => {
      const regions = worldCountries.getAllRegions();
      expect(Array.isArray(regions)).toBe(true);
      expect(regions.length).toBeGreaterThan(0);
      expect(regions.includes('Europe')).toBe(true);
      expect(regions.includes('Asia')).toBe(true);
    });
  });

  describe('getAllContinents', () => {
    it('should return all unique continents', () => {
      const continents = worldCountries.getAllContinents();
      expect(Array.isArray(continents)).toBe(true);
      expect(continents.length).toBe(7); // 7 continents
    });
  });

  describe('count', () => {
    it('should return the total number of countries', () => {
      const count = worldCountries.count();
      expect(count).toBe(250);
    });
  });

  describe('getByArea', () => {
    it('should filter countries by minimum area', () => {
      const largeCountries = worldCountries.getByArea(1000000);
      expect(largeCountries.length).toBeGreaterThan(0);
      expect(largeCountries.every(c => c.area >= 1000000)).toBe(true);
    });

    it('should filter countries by area range', () => {
      const mediumCountries = worldCountries.getByArea(100000, 500000);
      expect(mediumCountries.every(c => c.area >= 100000 && c.area <= 500000)).toBe(true);
    });
  });

  describe('getByPopulation', () => {
    it('should filter countries by minimum population', () => {
      const populousCountries = worldCountries.getByPopulation(100000000);
      expect(populousCountries.length).toBeGreaterThan(0);
      expect(populousCountries.every(c => c.population >= 100000000)).toBe(true);
    });

    it('should filter countries by population range', () => {
      const midSizeCountries = worldCountries.getByPopulation(10000000, 50000000);
      expect(midSizeCountries.every(c => c.population >= 10000000 && c.population <= 50000000)).toBe(true);
    });
  });

  describe('sortByName', () => {
    it('should sort countries by name in ascending order', () => {
      const sorted = worldCountries.sortByName('asc');
      expect(sorted[0].name.common < sorted[sorted.length - 1].name.common).toBe(true);
      
      for (let i = 1; i < sorted.length; i++) {
        expect(sorted[i - 1].name.common.localeCompare(sorted[i].name.common)).toBeLessThanOrEqual(0);
      }
    });

    it('should sort countries by name in descending order', () => {
      const sorted = worldCountries.sortByName('desc');
      expect(sorted[0].name.common > sorted[sorted.length - 1].name.common).toBe(true);
    });
  });

  describe('sortByPopulation', () => {
    it('should sort countries by population in descending order by default', () => {
      const sorted = worldCountries.sortByPopulation();
      expect(sorted[0].population >= sorted[sorted.length - 1].population).toBe(true);
    });

    it('should sort countries by population in ascending order', () => {
      const sorted = worldCountries.sortByPopulation('asc');
      expect(sorted[0].population <= sorted[sorted.length - 1].population).toBe(true);
    });
  });

  describe('sortByArea', () => {
    it('should sort countries by area in descending order by default', () => {
      const sorted = worldCountries.sortByArea();
      expect(sorted[0].area >= sorted[sorted.length - 1].area).toBe(true);
    });

    it('should sort countries by area in ascending order', () => {
      const sorted = worldCountries.sortByArea('asc');
      expect(sorted[0].area <= sorted[sorted.length - 1].area).toBe(true);
    });
  });
});