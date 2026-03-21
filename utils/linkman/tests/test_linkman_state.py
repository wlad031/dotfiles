import os
import sys
import tempfile
import unittest
from pathlib import Path

LINKMAN_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(LINKMAN_DIR))

import linkman


class LinkmanStateTests(unittest.TestCase):
    def setUp(self):
        self.tmpdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tmpdir.name)
        self.state_file = self.root / ".link_state"
        self.old_state_file = linkman.STATE_FILE
        linkman.STATE_FILE = str(self.state_file)

    def tearDown(self):
        linkman.STATE_FILE = self.old_state_file
        self.tmpdir.cleanup()

    def test_apply_links_and_updates_state(self):
        src = self.root / "src.txt"
        dst = self.root / "dst.txt"
        src.write_text("ok", encoding="utf-8")

        config = {f"core::{src}": str(dst)}
        sections = {"core"}
        linkman.apply(config, {}, sections, dry_run=False)

        self.assertTrue(dst.is_symlink())
        self.assertTrue(linkman.same_link_target(str(dst), str(src)))

        state = linkman.parse_state(str(self.state_file))
        self.assertEqual(state.get(f"core::{src}"), str(dst))

    def test_apply_skips_existing_non_symlink(self):
        src = self.root / "src.txt"
        dst = self.root / "dst.txt"
        src.write_text("ok", encoding="utf-8")
        dst.write_text("existing", encoding="utf-8")

        config = {f"core::{src}": str(dst)}
        sections = {"core"}
        linkman.apply(config, {}, sections, dry_run=False)

        self.assertFalse(dst.is_symlink())
        state = linkman.parse_state(str(self.state_file))
        self.assertNotIn(f"core::{src}", state)

    def test_apply_cleans_removed_entry(self):
        src = self.root / "src.txt"
        dst = self.root / "dst.txt"
        src.write_text("ok", encoding="utf-8")
        os.symlink(src, dst)

        state = {f"core::{src}": str(dst)}
        config = {}
        sections = {"core"}

        linkman.apply(config, state, sections, dry_run=False)

        self.assertFalse(dst.exists())
        new_state = linkman.parse_state(str(self.state_file))
        self.assertNotIn(f"core::{src}", new_state)


if __name__ == "__main__":
    unittest.main()
