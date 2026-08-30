import requests
import pandas as pd
from pathlib import Path
from datetime import datetime, timezone


COUNTRIES = {
    "KEN": "Kenya",
    "NGA": "Nigeria",
    "GHA": "Ghana",
    "ZAF": "South Africa",
}

INDICATORS = {
    "SP.POP.TOTL": "population",
    "NY.GDP.PCAP.CD": "gdp_per_capita",
    "IT.NET.USER.ZS": "internet_penetration",
}

BASE_URL = "https://api.worldbank.org/v2"

OUTPUT_DIR = Path("data/raw/world_bank")
OUTPUT_FILE = OUTPUT_DIR / "world_bank_indicators.csv"


def fetch_indicator(country_codes, indicator_code):
    countries = ";".join(country_codes)

    url = (
        f"{BASE_URL}/country/{countries}/indicator/"
        f"{indicator_code}"
    )

    params = {
    "format": "json",
    "date": "2015:2025",
    "per_page": 1000,
}

    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()

    data = response.json()

    if len(data) < 2:
        raise ValueError(f"No data returned for {indicator_code}")

    return data[1]


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    records = []

    for indicator_code, indicator_name in INDICATORS.items():

        data = fetch_indicator(
            COUNTRIES.keys(),
            indicator_code
        )

        for row in data:
            records.append({
                "country_code": row["countryiso3code"],
                "country": row["country"]["value"],
                "indicator_code": indicator_code,
                "indicator_name": indicator_name,
                "year": int(row["date"]),
                "value": row["value"],
                "source": "World Bank",
                "extracted_at": datetime.now(timezone.utc).isoformat(),
            })

    df = pd.DataFrame(records)

    df = df[
        df["country_code"].isin(COUNTRIES.keys())
    ].copy()

    df = df.sort_values(
        ["country_code", "indicator_code", "year"]
    )

    df.to_csv(OUTPUT_FILE, index=False)

    print(f"Saved {len(df)} records to {OUTPUT_FILE}")
    print(f"Countries: {df['country'].nunique()}")
    print(f"Indicators: {df['indicator_code'].nunique()}")
    print(
        f"Year range: "
        f"{df['year'].min()} - {df['year'].max()}"
    )


if __name__ == "__main__":
    main()