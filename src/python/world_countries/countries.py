import json
import os
from typing import Dict, List, Optional, Any


class WorldCountries:
    def __init__(self) -> None:
        json_path = os.path.join(
            os.path.dirname(__file__), "..", "..", "..", "data", "world-countries.json"
        )
        with open(json_path, "r", encoding="utf-8") as f:
            self.countries: List[Dict[str, Any]] = json.load(f)

    def get_all(self) -> List[Dict[str, Any]]:
        return self.countries

    def get_by_alpha2_code(self, code: str) -> Optional[Dict[str, Any]]:
        code_upper = code.upper()
        for country in self.countries:
            if country["cca2"] == code_upper:
                return country
        return None

    def get_by_alpha3_code(self, code: str) -> Optional[Dict[str, Any]]:
        code_upper = code.upper()
        for country in self.countries:
            if country["cca3"] == code_upper:
                return country
        return None

    def get_by_numeric_code(self, code: str) -> Optional[Dict[str, Any]]:
        for country in self.countries:
            if country["ccn3"] == str(code):
                return country
        return None

    def get_by_common_name(self, name: str) -> Optional[Dict[str, Any]]:
        name_lower = name.lower()
        for country in self.countries:
            if country["name"]["common"].lower() == name_lower:
                return country
        return None

    def get_by_official_name(self, name: str) -> Optional[Dict[str, Any]]:
        name_lower = name.lower()
        for country in self.countries:
            if country["name"]["official"].lower() == name_lower:
                return country
        return None

    def get_by_region(self, region: str) -> List[Dict[str, Any]]:
        region_lower = region.lower()
        return [
            country
            for country in self.countries
            if country["region"].lower() == region_lower
        ]

    def get_by_subregion(self, subregion: str) -> List[Dict[str, Any]]:
        subregion_lower = subregion.lower()
        return [
            country
            for country in self.countries
            if country["subregion"].lower() == subregion_lower
        ]

    def get_by_currency(self, currency_code: str) -> List[Dict[str, Any]]:
        code_upper = currency_code.upper()
        return [
            country
            for country in self.countries
            if code_upper in country["currencies"]
        ]

    def get_by_language(self, language_code: str) -> List[Dict[str, Any]]:
        code_lower = language_code.lower()
        return [
            country
            for country in self.countries
            if code_lower in country["languages"]
        ]

    def get_by_capital(self, capital: str) -> List[Dict[str, Any]]:
        capital_lower = capital.lower()
        result = []
        for country in self.countries:
            for cap in country["capital"]:
                if cap.lower() == capital_lower:
                    result.append(country)
                    break
        return result

    def get_by_continent(self, continent: str) -> List[Dict[str, Any]]:
        continent_lower = continent.lower()
        result = []
        for country in self.countries:
            for cont in country["continents"]:
                if cont.lower() == continent_lower:
                    result.append(country)
                    break
        return result

    def get_by_borders(self, country_code: str) -> List[Dict[str, Any]]:
        code_upper = country_code.upper()
        return [
            country
            for country in self.countries
            if code_upper in country["borders"]
        ]

    def get_landlocked(self) -> List[Dict[str, Any]]:
        return [
            country
            for country in self.countries
            if country["landlocked"] is True
        ]

    def get_independent(self) -> List[Dict[str, Any]]:
        return [
            country
            for country in self.countries
            if country["independent"] is True
        ]

    def get_un_members(self) -> List[Dict[str, Any]]:
        return [
            country
            for country in self.countries
            if country["unMember"] is True
        ]

    def search(self, query: str) -> List[Dict[str, Any]]:
        search_term = query.lower()
        result = []
        for country in self.countries:
            if (
                search_term in country["name"]["common"].lower()
                or search_term in country["name"]["official"].lower()
                or search_term in country["cca2"].lower()
                or search_term in country["cca3"].lower()
            ):
                result.append(country)
                continue
            
            found = False
            for capital in country["capital"]:
                if search_term in capital.lower():
                    result.append(country)
                    found = True
                    break
            
            if not found:
                for alt in country["altSpellings"]:
                    if search_term in alt.lower():
                        result.append(country)
                        break
        
        return result

    def get_by_timezone(self, timezone: str) -> List[Dict[str, Any]]:
        return [
            country
            for country in self.countries
            if timezone in country["timezones"]
        ]

    def get_by_calling_code(self, code: str) -> List[Dict[str, Any]]:
        result = []
        for country in self.countries:
            full_code = country["idd"]["root"] + "".join(country["idd"]["suffixes"])
            if str(code) in full_code:
                result.append(country)
        return result

    def get_all_currencies(self) -> List[str]:
        currencies = set()
        for country in self.countries:
            currencies.update(country["currencies"].keys())
        return sorted(list(currencies))

    def get_all_languages(self) -> List[str]:
        languages = set()
        for country in self.countries:
            languages.update(country["languages"].keys())
        return sorted(list(languages))

    def get_all_capitals(self) -> List[str]:
        capitals = set()
        for country in self.countries:
            capitals.update(country["capital"])
        return sorted(list(capitals))

    def get_all_regions(self) -> List[str]:
        regions = set()
        for country in self.countries:
            regions.add(country["region"])
        return sorted(list(regions))

    def get_all_subregions(self) -> List[str]:
        subregions = set()
        for country in self.countries:
            subregions.add(country["subregion"])
        return sorted(list(subregions))

    def get_all_continents(self) -> List[str]:
        continents = set()
        for country in self.countries:
            continents.update(country["continents"])
        return sorted(list(continents))

    def get_all_timezones(self) -> List[str]:
        timezones = set()
        for country in self.countries:
            timezones.update(country["timezones"])
        return sorted(list(timezones))

    def count(self) -> int:
        return len(self.countries)

    def get_by_area(
        self, min_area: Optional[float] = None, max_area: Optional[float] = None
    ) -> List[Dict[str, Any]]:
        result = []
        for country in self.countries:
            if min_area is not None and country["area"] < min_area:
                continue
            if max_area is not None and country["area"] > max_area:
                continue
            result.append(country)
        return result

    def get_by_population(
        self, min_pop: Optional[int] = None, max_pop: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        result = []
        for country in self.countries:
            if min_pop is not None and country["population"] < min_pop:
                continue
            if max_pop is not None and country["population"] > max_pop:
                continue
            result.append(country)
        return result

    def sort_by_name(self, order: str = "asc") -> List[Dict[str, Any]]:
        sorted_countries = sorted(
            self.countries, key=lambda x: x["name"]["common"]
        )
        return sorted_countries if order == "asc" else sorted_countries[::-1]

    def sort_by_population(self, order: str = "desc") -> List[Dict[str, Any]]:
        sorted_countries = sorted(
            self.countries, key=lambda x: x["population"]
        )
        return sorted_countries[::-1] if order == "desc" else sorted_countries

    def sort_by_area(self, order: str = "desc") -> List[Dict[str, Any]]:
        sorted_countries = sorted(
            self.countries, key=lambda x: x["area"]
        )
        return sorted_countries[::-1] if order == "desc" else sorted_countries