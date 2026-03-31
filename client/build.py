import os
import re

# read pubspec.yaml
content = ""
with open("pubspec.yaml", "r", encoding="utf-8") as f:
    content = f.read()


# find the current build number
build_match = re.search(r"version: (\d+).(\d+).(\d+)\+(\d+)", content)
if build_match:

    major = int(build_match.group(1))
    # print(f"major : {major}")

    minor = int(build_match.group(2))
    # print(f"minor : {minor}")

    patch = int(build_match.group(3))
    # print(f"patch : {patch}")

    build_num = int(build_match.group(4))
    new_build_num = build_num + 1

    # update the build number in pubspec.yaml content
    new_content = re.sub(
        r"version: (\d+)\.(\d+)\.(\d+)\+(\d+)",
        f"version: {build_match.group(1)}.{build_match.group(2)}.{build_match.group(3)}+{new_build_num}",
        content,
    )
    # print(new_content)

    # write back to env.dart
    with open("pubspec.yaml", "w", encoding="utf-8") as f:
        f.write(new_content)


# clean
# os.system("flutter clean")

# build web release
os.system("flutter build web --release --base-href /")
