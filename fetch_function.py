import os
import requests
import re

PACKAGES_DIR = "packages"

def get_repo_url(content):
    # Find repository link specifically
    lines = content.splitlines()
    for i, line in enumerate(lines):
        if 'label: repository' in line or 'label: "repository"' in line:
            # URL is on the next line
            for j in range(i+1, min(i+3, len(lines))):
                if 'url:' in lines[j]:
                    url = lines[j].split('url:')[-1].strip().strip('"')
                    if 'github.com' in url:
                        return url
    return None

def fetch_index(repo_url):
    for branch in ["main", "master"]:
        raw_url = repo_url.replace(
            "https://github.com/",
            "https://raw.githubusercontent.com/"
        ) + f"/{branch}/INDEX"
        try:
            response = requests.get(raw_url, timeout=10)
            if response.status_code == 200:
                return response.text
        except Exception:
            continue
    return None

def parse_index(content):
    categories = {}
    current_category = "General"
    for line in content.splitlines():
        if not line.strip():
            continue
        if ">>" in line:
            current_category = line.split(">>")[1].strip()
        elif line.startswith(" ") or line.startswith("\t"):
            func = line.strip()
            if func:
                categories.setdefault(current_category, []).append(func)
    return categories

def functions_to_yaml(categories):
    lines = ["functions:"]
    for cat, funcs in categories.items():
        lines.append(f"  {cat}:")
        for func in funcs:
            lines.append(f"  - '{func}'")
    return "\n".join(lines) + "\n"

def main():
    for filename in os.listdir(PACKAGES_DIR):
        if not filename.endswith(".yaml"):
            continue
        filepath = os.path.join(PACKAGES_DIR, filename)
        with open(filepath, "r") as f:
            content = f.read()

        if "functions:" in content:
            continue

        repo_url = get_repo_url(content)
        if not repo_url:
            continue

        print(f"Processing {filename}...")
        index_content = fetch_index(repo_url)
        if not index_content:
            print(f"  No INDEX file found")
            continue

        categories = parse_index(index_content)
        print(f"  Found {sum(len(v) for v in categories.values())} functions")

        last_separator = content.rfind("---")
        new_content = content[:last_separator] + functions_to_yaml(categories) + content[last_separator:]

        with open(filepath, "w") as f:
            f.write(new_content)
        print(f"  Updated {filename}")

if __name__ == "__main__":
    main()
