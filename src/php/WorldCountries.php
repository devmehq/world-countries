<?php

namespace DevMe\WorldCountries;

class WorldCountries
{
    private array $countries;

    public function __construct()
    {
        $jsonPath = __DIR__ . '/../../data/world-countries.json';
        $jsonContent = file_get_contents($jsonPath);
        $this->countries = json_decode($jsonContent, true);
    }

    public function getAll(): array
    {
        return $this->countries;
    }

    public function getByAlpha2Code(string $code): ?array
    {
        $code = strtoupper($code);
        foreach ($this->countries as $country) {
            if ($country['cca2'] === $code) {
                return $country;
            }
        }
        return null;
    }

    public function getByAlpha3Code(string $code): ?array
    {
        $code = strtoupper($code);
        foreach ($this->countries as $country) {
            if ($country['cca3'] === $code) {
                return $country;
            }
        }
        return null;
    }

    public function getByNumericCode(string $code): ?array
    {
        foreach ($this->countries as $country) {
            if ($country['ccn3'] === $code) {
                return $country;
            }
        }
        return null;
    }

    public function getByCommonName(string $name): ?array
    {
        $nameLower = strtolower($name);
        foreach ($this->countries as $country) {
            if (strtolower($country['name']['common']) === $nameLower) {
                return $country;
            }
        }
        return null;
    }

    public function getByOfficialName(string $name): ?array
    {
        $nameLower = strtolower($name);
        foreach ($this->countries as $country) {
            if (strtolower($country['name']['official']) === $nameLower) {
                return $country;
            }
        }
        return null;
    }

    public function getByRegion(string $region): array
    {
        $result = [];
        $regionLower = strtolower($region);
        foreach ($this->countries as $country) {
            if (strtolower($country['region']) === $regionLower) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getBySubregion(string $subregion): array
    {
        $result = [];
        $subregionLower = strtolower($subregion);
        foreach ($this->countries as $country) {
            if (strtolower($country['subregion']) === $subregionLower) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getByCurrency(string $currencyCode): array
    {
        $result = [];
        $code = strtoupper($currencyCode);
        foreach ($this->countries as $country) {
            if (isset($country['currencies'][$code])) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getByLanguage(string $languageCode): array
    {
        $result = [];
        $code = strtolower($languageCode);
        foreach ($this->countries as $country) {
            if (isset($country['languages'][$code])) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getByCapital(string $capital): array
    {
        $result = [];
        $capitalLower = strtolower($capital);
        foreach ($this->countries as $country) {
            foreach ($country['capital'] as $cap) {
                if (strtolower($cap) === $capitalLower) {
                    $result[] = $country;
                    break;
                }
            }
        }
        return $result;
    }

    public function getByContinent(string $continent): array
    {
        $result = [];
        $continentLower = strtolower($continent);
        foreach ($this->countries as $country) {
            foreach ($country['continents'] as $cont) {
                if (strtolower($cont) === $continentLower) {
                    $result[] = $country;
                    break;
                }
            }
        }
        return $result;
    }

    public function getByBorders(string $countryCode): array
    {
        $result = [];
        $code = strtoupper($countryCode);
        foreach ($this->countries as $country) {
            if (in_array($code, $country['borders'])) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getLandlocked(): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if ($country['landlocked'] === true) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getIndependent(): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if ($country['independent'] === true) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getUNMembers(): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if ($country['unMember'] === true) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function search(string $query): array
    {
        $result = [];
        $searchTerm = strtolower($query);
        
        foreach ($this->countries as $country) {
            $found = false;
            
            if (stripos($country['name']['common'], $searchTerm) !== false ||
                stripos($country['name']['official'], $searchTerm) !== false ||
                stripos($country['cca2'], $searchTerm) !== false ||
                stripos($country['cca3'], $searchTerm) !== false) {
                $found = true;
            }
            
            if (!$found) {
                foreach ($country['capital'] as $capital) {
                    if (stripos($capital, $searchTerm) !== false) {
                        $found = true;
                        break;
                    }
                }
            }
            
            if (!$found) {
                foreach ($country['altSpellings'] as $spelling) {
                    if (stripos($spelling, $searchTerm) !== false) {
                        $found = true;
                        break;
                    }
                }
            }
            
            if ($found) {
                $result[] = $country;
            }
        }
        
        return $result;
    }

    public function getByTimezone(string $timezone): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if (in_array($timezone, $country['timezones'])) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getByCallingCode(string $code): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            $fullCode = $country['idd']['root'] . implode('', $country['idd']['suffixes']);
            if (strpos($fullCode, $code) !== false) {
                $result[] = $country;
            }
        }
        return $result;
    }

    public function getAllCurrencies(): array
    {
        $currencies = [];
        foreach ($this->countries as $country) {
            foreach (array_keys($country['currencies']) as $currency) {
                $currencies[] = $currency;
            }
        }
        return array_unique($currencies);
    }

    public function getAllLanguages(): array
    {
        $languages = [];
        foreach ($this->countries as $country) {
            foreach (array_keys($country['languages']) as $language) {
                $languages[] = $language;
            }
        }
        return array_unique($languages);
    }

    public function getAllCapitals(): array
    {
        $capitals = [];
        foreach ($this->countries as $country) {
            foreach ($country['capital'] as $capital) {
                $capitals[] = $capital;
            }
        }
        return array_unique($capitals);
    }

    public function getAllRegions(): array
    {
        $regions = [];
        foreach ($this->countries as $country) {
            $regions[] = $country['region'];
        }
        return array_unique($regions);
    }

    public function getAllSubregions(): array
    {
        $subregions = [];
        foreach ($this->countries as $country) {
            $subregions[] = $country['subregion'];
        }
        return array_unique($subregions);
    }

    public function getAllContinents(): array
    {
        $continents = [];
        foreach ($this->countries as $country) {
            foreach ($country['continents'] as $continent) {
                $continents[] = $continent;
            }
        }
        return array_unique($continents);
    }

    public function getAllTimezones(): array
    {
        $timezones = [];
        foreach ($this->countries as $country) {
            foreach ($country['timezones'] as $timezone) {
                $timezones[] = $timezone;
            }
        }
        return array_unique($timezones);
    }

    public function count(): int
    {
        return count($this->countries);
    }

    public function getByArea(?float $minArea = null, ?float $maxArea = null): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if ($minArea !== null && $country['area'] < $minArea) {
                continue;
            }
            if ($maxArea !== null && $country['area'] > $maxArea) {
                continue;
            }
            $result[] = $country;
        }
        return $result;
    }

    public function getByPopulation(?int $minPop = null, ?int $maxPop = null): array
    {
        $result = [];
        foreach ($this->countries as $country) {
            if ($minPop !== null && $country['population'] < $minPop) {
                continue;
            }
            if ($maxPop !== null && $country['population'] > $maxPop) {
                continue;
            }
            $result[] = $country;
        }
        return $result;
    }

    public function sortByName(string $order = 'asc'): array
    {
        $countries = $this->countries;
        usort($countries, function($a, $b) use ($order) {
            $result = strcmp($a['name']['common'], $b['name']['common']);
            return $order === 'desc' ? -$result : $result;
        });
        return $countries;
    }

    public function sortByPopulation(string $order = 'desc'): array
    {
        $countries = $this->countries;
        usort($countries, function($a, $b) use ($order) {
            $result = $a['population'] - $b['population'];
            return $order === 'desc' ? -$result : $result;
        });
        return $countries;
    }

    public function sortByArea(string $order = 'desc'): array
    {
        $countries = $this->countries;
        usort($countries, function($a, $b) use ($order) {
            $result = $a['area'] - $b['area'];
            return $order === 'desc' ? -$result : $result;
        });
        return $countries;
    }
}