from typing import Dict, Set

STATE_FILE: str

def parse_state(file_path: str) -> Dict[str, str]: ...
def same_link_target(dst: str, src: str) -> bool: ...
def apply(
    config: Dict[str, str],
    state: Dict[str, str],
    sections: Set[str],
    dry_run: bool,
) -> None: ...
