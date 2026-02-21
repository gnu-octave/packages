import os
import requests
import yaml

PACKAGES_DIR = "packages"

def get_repo_url(links):
    for link in links:
        if link.get("label") == "repository":
            return link.get("url")
    return None

def fetch_index(repo_url):
    # Convert GitHub repo URL to raw INDEX file URL
    # Try main and master branches
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

def main():
    for filename in os.listdir(PACKAGES_DIR):
        if not filename.endswith(".yaml"):
            continue
        filepath = os.path.join(PACKAGES_DIR, filename)
        with open(filepath, "r") as f:
            content = f.read()
        # Split front matter
        parts = content.split("---", 2)
        if len(parts) < 3:
            continue
        data = yaml.safe_load(parts[1])
        links = data.get("links", [])
        repo_url = get_repo_url(links)
        if not repo_url or "github.com" not in repo_url:
            continue
        print(f"Processing {filename}...")
        index_content = fetch_index(repo_url)
        if not index_content:
            print(f"  No INDEX file found for {filename}")
            continue
        categories = parse_index(index_content)
        print(f"  Found {sum(len(v) for v in categories.values())} functions")
        # Add functions to YAML data
        data["functions"] = categories
        # Rewrite file
        new_front_matter = yaml.dump(data, allow_unicode=True, sort_keys=False)
        new_content = f"---\n{new_front_matter}---\n{parts[2]}"
        with open(filepath, "w") as f:
            f.write(new_content)
        print(f"  Updated {filename}")

if __name__ == "__main__":
    main()
