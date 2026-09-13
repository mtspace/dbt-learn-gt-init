import holidays
import pandas

def model(dbt, session):
    dbt.config(materialized="table", packages=["holidays", "pandas", "pyarrow"])

    us_holidays = holidays.US(years=2026)

    df = dbt.ref('date_spine').to_pandas()

    # Add a column to indicate if the date is a holiday
    df["IS_HOLIDAY"] = df["DATE_DAY"].isin(us_holidays)

    return df