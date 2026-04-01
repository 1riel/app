import json
from urllib.parse import urlparse, parse_qs

url = "https://8000.1riel.com/auth/telegram?id=6410512787&first_name=%E1%9E%98%E1%9E%BB%E1%9E%99%20%E1%9E%9F%E1%9F%81%E1%9E%84%E1%9E%9B%E1%9E%B8%20-%20MUY%20Sengly&username=muysengly&photo_url=https%3A%2F%2Ft.me%2Fi%2Fuserpic%2F320%2FRUhjKW-o8xNm9L1pDg7i2oTCTjhxao4L0Sle0pJ3OIgMnAB_C1ZiBre2QtXYQf_w.jpg&auth_date=1775065410&hash=0c8cb1cf5365f8b6c7faf497b287ffa51a1073f2b960c462d55924f3c4cadacd"

parsed = urlparse(url)
qs = parse_qs(parsed.query, keep_blank_values=True)

# parse_qs returns lists; flatten to single values
data = {k: v[0] for k, v in qs.items()}

# optionally cast types
data["id"] = int(data["id"])
data["auth_date"] = int(data["auth_date"])

print(data)
print(json.dumps(data, ensure_ascii=False, indent=2))
