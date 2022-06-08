def calendar_json_test() -> js:
    now = dt.datetime.now(dt.timezone.utc) # Another way to import
    return js.dumps(now, default=date_to_json)
