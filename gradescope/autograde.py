import json
import shutil
from pathlib import Path
import xml.etree.ElementTree as ET
import os
from pathlib import Path
import argparse

def detect_environment():
    # True Gradescope environment
    if (
        os.name == "posix"
        and Path("/autograder/submission").exists()
        and Path("/autograder/source").exists()
    ):
        return "gradescope"
    return "local"


ENV = detect_environment()

if ENV == "gradescope":
    # Real Gradescope container
    SOURCE_DIR = Path("/autograder/source")
    SUBMISSION_DIR = Path("/autograder/submission")
    RESULTS_PATH = Path("/autograder/results/results.json")

else:
    # Local testing mode
    # cwd = lab/autograder
    CWD = Path.cwd()

    SOURCE_DIR = CWD
    SUBMISSION_DIR = CWD.parent / "submission"
    RESULTS_PATH = CWD.parent / "results.json"

    # Ensure local submission directory exists
    SUBMISSION_DIR.mkdir(exist_ok=True)

CONFIG_PATH = SOURCE_DIR / "autograder_config.xml"
STUDENT_RESULTS = SUBMISSION_DIR / "submitted_results.json"


def load_config(path):
    tree = ET.parse(path)
    root = tree.getroot()
    required = [f.text.strip() for f in root.findall("./required_files/file")]
    return {"required_files": required}


def write_error(message, verbose=False):
    """Write a Gradescope-style failure JSON."""
    if verbose:
        print(f"ERROR: {message}")
    error_json = {
        "score": 0,
        "tests": [
            {
                "name": "Autograder Error",
                "score": 0,
                "max_score": 0,
                "output": message
            }
        ]
    }
    with open(RESULTS_PATH, "w") as f:
        json.dump(error_json, f, indent=2)


def main():
    parser = argparse.ArgumentParser(description='Run autograder for Gradescope')
    parser.add_argument('--verbose', action='store_true', default=False,
                        help='Print diagnostic information (default: False)')
    parser.add_argument('--submission', type=str, default=None,
                        help='Alternate submission directory (default: SUBMISSION_DIR)')
    args = parser.parse_args()
    
    verbose = args.verbose
    submission_dir = Path(args.submission) if args.submission else SUBMISSION_DIR
    student_results = submission_dir / "submitted_results.json"
    
    if verbose:
        print(f"Detected environment: {ENV}")
        print(f"SOURCE_DIR: {SOURCE_DIR}")
        print(f"SUBMISSION_DIR: {submission_dir}")
        print(f"RESULTS_PATH: {RESULTS_PATH}")
        print(f"CONFIG_PATH: {CONFIG_PATH}")
        print(f"STUDENT_RESULTS: {student_results}")
    
    # 1. Load config
    if not CONFIG_PATH.exists():
        write_error("Missing autograder_config.xml in autograder source directory.", verbose)
        return

    config = load_config(CONFIG_PATH)
    
    if verbose:
        print(f"Loaded config: {config}")

    # 2. Check required files
    missing = []
    for fname in config["required_files"]:
        if not (submission_dir / fname).exists():
            missing.append(fname)

    if missing:
        write_error(f"Missing required submission files: {', '.join(missing)}", verbose)
        return

    # 3. Check results.json
    if not student_results.exists():
        write_error("Missing results.json in student submission.", verbose)
        return

    # 4. Copy results.json directly to Gradescope results
    try:
        shutil.copy(student_results, RESULTS_PATH)
        if verbose:
            print(f"Successfully copied {student_results} to {RESULTS_PATH}")
    except Exception as e:
        write_error(f"Failed to copy results.json: {e}", verbose)
        return


if __name__ == "__main__":
    main()