#!/usr/bin/env python3

import argparse
import subprocess
import os
import yaml
from pathlib import Path
import logging
from typing import Set

# Rich Imports (Optional)
from rich.console import Console
from rich.table import Table
from rich.progress import track
from rich.panel import Panel

# Setup Logging
logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(message)s",
    level=logging.INFO
)
logger = logging.getLogger("dotfiles_stow")

# Setup Rich
console = Console()


# Output Utilities
class OutputHandler:
    def __init__(self, pretty: bool):
        self.pretty = pretty

    def info(self, message: str):
        if self.pretty:
            console.print(f"[bold cyan]{message}[/bold cyan]")
        else:
            logger.info(message)

    def success(self, message: str):
        if self.pretty:
            console.print(f"[bold green]{message}[/bold green]")
        else:
            logger.info(message)

    def warning(self, message: str):
        if self.pretty:
            console.print(f"[yellow]{message}[/yellow]")
        else:
            logger.warning(message)

    def error(self, message: str):
        if self.pretty:
            console.print(f"[bold red]{message}[/bold red]")
        else:
            logger.error(message)
        exit(1)

    def table(self, title: str, data: dict):
        if not self.pretty:
            logger.info(title)
            for key, value in data.items():
                logger.info(f"{key}: {value}")
            return

        table = Table(title=title, style="bold magenta")
        table.add_column("Parameter", style="cyan", justify="right")
        table.add_column("Value", style="white")
        for key, value in data.items():
            table.add_row(key, str(value))
        console.print(table)

    def panel(self, message: str, style: str = "green"):
        if self.pretty:
            console.print(Panel(f"[bold]{message}[/bold]", style=style))
        else:
            logger.info(message)

    def progress(self, items: Set[str], description: str):
        return track(items, description=description) if self.pretty else items


def parse_args():
    parser = argparse.ArgumentParser(
        description="Install dotfiles using GNU Stow with support for tags."
    )
    parser.add_argument(
        "-i", "--inventory", required=True, type=Path,
        help="Path to the inventory YAML file"
    )
    parser.add_argument(
        "-s", "--source", required=True, type=Path,
        help="Source directory containing stow packages"
    )
    parser.add_argument(
        "-t", "--target", required=True, type=Path,
        help="Target directory where stow will symlink files"
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Perform a dry run without making changes"
    )
    parser.add_argument(
        "--adopt", action="store_true", help="Import existing files into Stow package"
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Enable verbose output"
    )
    parser.add_argument(
        "--tag", action="append", required=True,
        help="Specify tags (can be used multiple times)"
    )
    parser.add_argument(
        "--pretty", action="store_true", default=True,
        help="Enable pretty output using Rich (default: True)"
    )

    return parser.parse_args()


def load_inventory(inventory_file: Path, output: OutputHandler):
    if not inventory_file.exists():
        output.error(f"Inventory file not found: {inventory_file}")
    
    with open(inventory_file, "r") as file:
        try:
            inventory = yaml.safe_load(file)
            return inventory or {}
        except yaml.YAMLError as e:
            output.error(f"Failed to parse inventory file: {e}")


def collect_items_from_tags(inventory, tags, output: OutputHandler) -> Set[str]:
    selected_items = set()
    for tag in tags:
        if tag not in inventory:
            output.warning(f"Tag '{tag}' not found in inventory")
            continue
        selected_items.update(inventory[tag])
    
    if not selected_items:
        output.error("No valid items found for the provided tags.")
    
    # Extract unique root-level package names
    root_packages = {item.split('/')[0] for item in selected_items}
    return root_packages


def stow_item(package, source_dir, target_dir, dry_run=False, adopt=False, verbose=False, output=None):
    stow_cmd = [
        "stow",
        "--override=.*",
        "-d", str(source_dir),
        "-t", str(target_dir),
        package
    ]
    
    if dry_run:
        stow_cmd.append("--simulate")
    if adopt:
        stow_cmd.append("--adopt")
    if verbose:
        stow_cmd.append("-v")
    
    output.info(f"Executing: {' '.join(stow_cmd)}")
    
    try:
        subprocess.run(stow_cmd, check=True)
    except subprocess.CalledProcessError as e:
        output.error(f"Failed to stow {package}: {e}")


def display_summary(source, target, tags, selected_items, dry_run, adopt, output: OutputHandler):
    output.table(
        title="Stow Configuration Summary",
        data={
            "Source Directory": str(source),
            "Target Directory": str(target),
            "Tags": ", ".join(tags),
            "Dry Run": str(dry_run),
            "Adopt Mode": str(adopt),
            "Selected Packages": ", ".join(selected_items)
        }
    )
    output.panel("Starting Dotfiles Installation...", style="green")


def main():
    args = parse_args()
    output = OutputHandler(pretty=args.pretty)
    
    inventory = load_inventory(args.inventory, output)
    selected_items = collect_items_from_tags(inventory, args.tag, output)
    
    display_summary(
        source=args.source,
        target=args.target,
        tags=args.tag,
        selected_items=selected_items,
        dry_run=args.dry_run,
        adopt=args.adopt,
        output=output
    )
    
    for package in output.progress(selected_items, "Processing stow packages..."):
        stow_item(
            package=package,
            source_dir=args.source,
            target_dir=args.target,
            dry_run=args.dry_run,
            adopt=args.adopt,
            verbose=args.verbose,
            output=output
        )
    
    output.panel("Dotfiles Installation Completed!", style="green")


if __name__ == "__main__":
    main()

