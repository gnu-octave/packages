# Validate YAML files in the ./packages directory
# The schema is defined in the CONTRIBUTING.md file

import yaml
import os


def load_yaml(file_path) -> dict:
    try:
        with open(file_path, "r") as file:
            return next(yaml.safe_load_all(file))
    except yaml.YAMLError as e:
        print(f"Error in YAML file {file_path}: {e}")
        return {}


def validate_top_level_keys(yaml_data: dict) -> str:
    expected_keys = [
        "layout",
        "permalink",
        "description",
        "icon",
        "links",
        "maintainers",
        "versions",
    ]
    actual_keys = list(yaml_data.keys())
    return (
        f"Top level object keys do not match.\n    Expected: {expected_keys}\n    Found:    {actual_keys}"
        if actual_keys != expected_keys
        else ""
    )


def validate_string(yaml_data: dict, key: str, allow_empty: bool = False) -> str:
    if key in yaml_data:
        if allow_empty and not yaml_data[key]:
            return ""
        return (
            f"'{key}' should be a string, found {type(yaml_data[key])}"
            if not isinstance(yaml_data[key], str)
            else ""
        )
    else:
        return f"Key '{key}' not found in YAML data."


def validate_list(yaml_data: dict, key: str, expected_keys: list[str]) -> str:
    for idx, item in enumerate(yaml_data[key]):
        if not isinstance(item, dict):
            return f"'{key}[{idx}]' should be a dictionary, found {type(item)}"
        actual_keys = list(item.keys())  # may also contain optinal keys
        if actual_keys[: len(expected_keys)] != expected_keys:
            return f"'{key}[{idx}]' keys do not match.\n    Expected: {expected_keys}\n    Found:    {actual_keys}"
    return ""


def validate(yaml_data: dict) -> list[str]:
    messages = []
    messages.append(validate_top_level_keys(yaml_data))
    messages.append(validate_string(yaml_data, "layout"))
    messages.append(validate_string(yaml_data, "permalink"))
    messages.append(validate_string(yaml_data, "description"))
    messages.append(validate_string(yaml_data, "icon", allow_empty=True))
    messages.append(validate_list(yaml_data, "links", ["icon", "label", "url"]))
    messages.append(validate_list(yaml_data, "maintainers", ["name", "contact"]))
    messages.append(
        validate_list(yaml_data, "versions", ["id", "date", "sha256", "url", "depends"])
    )
    return messages


if __name__ == "__main__":
    exit_code = 0
    # Iterate over all YAML files in the ./packages directory
    for root, _, files in os.walk("./packages"):
        for file in sorted(files):
            if file.endswith(".yaml"):
                file_path = os.path.join(root, file)
                status = "✅"
                messages_display = ""
                messages = [msg for msg in validate(load_yaml(file_path)) if msg]
                if messages:
                    exit_code = 1
                    status = "❌"
                    messages_display = "\n" + "\n".join(
                        [f"  {msg}" for msg in messages if msg]
                    )
                print(f"{status} {file_path}{messages_display}")
    exit(exit_code)
