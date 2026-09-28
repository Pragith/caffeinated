#!/usr/bin/env python3
"""Render App Store artwork around unmodified captures of the shipped app."""

import base64
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SHOTS = ROOT / "docs" / "screenshots"
ICON = ROOT / "caffeinated/caffeinated/Assets.xcassets/AppIcon.appiconset/256.png"


def png_uri(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode()


def render(name: str, content: str) -> None:
    output = SHOTS / f"{name}.png"
    with tempfile.TemporaryDirectory(prefix="caffeinated-store-") as temp:
        source = Path(temp) / f"{name}.svg"
        source.write_text(content)
        subprocess.run(["rsvg-convert", "--output", str(output), str(source)], check=True)


def canvas(inner: str) -> str:
    return f'''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1280" height="800" viewBox="0 0 1280 800">
<defs>
  <linearGradient id="background" x2="1" y2="1"><stop stop-color="#F7F9FC"/><stop offset="1" stop-color="#EDF3F8"/></linearGradient>
  <linearGradient id="panel" x2="1" y2="1"><stop stop-color="#163450"/><stop offset="1" stop-color="#0A1D2F"/></linearGradient>
  <filter id="shadow" x="-30%" y="-30%" width="160%" height="160%"><feDropShadow dx="0" dy="16" stdDeviation="19" flood-color="#0C2035" flood-opacity=".25"/></filter>
</defs>
<rect width="1280" height="800" fill="url(#background)"/>
{inner}
</svg>'''


def brand(x: int, y: int) -> str:
    return f'''<image x="{x}" y="{y}" width="58" height="58" xlink:href="{png_uri(ICON)}"/>
<text x="{x+72}" y="{y+35}" font-family="Helvetica Neue,Arial,sans-serif" font-size="23" font-weight="700" fill="#15304B">Caffeinate-d</text>'''


menu = png_uri(SHOTS / "build_1.0_4_menu_with_durations_original.png")

render("app_store_01_one_click", canvas(f'''
{brand(65, 55)}
<text x="70" y="247" font-family="Helvetica Neue,Arial,sans-serif" font-size="62" font-weight="750" fill="#102D47">Stay awake.</text>
<text x="70" y="322" font-family="Helvetica Neue,Arial,sans-serif" font-size="62" font-weight="750" fill="#102D47">One click.</text>
<text x="72" y="390" font-family="Helvetica Neue,Arial,sans-serif" font-size="24" fill="#486477">Keep your display and system awake</text>
<text x="72" y="423" font-family="Helvetica Neue,Arial,sans-serif" font-size="24" fill="#486477">while you work, present, or download.</text>
<rect x="55" y="565" width="468" height="150" rx="30" fill="#DCEAF4"/>
<text x="82" y="626" font-family="Helvetica Neue,Arial,sans-serif" font-size="22" font-weight="650" fill="#194A69">A native Mac menu bar utility</text>
<text x="82" y="664" font-family="Helvetica Neue,Arial,sans-serif" font-size="19" fill="#486477">Quick control, always in reach.</text>
<rect x="578" y="145" width="647" height="535" rx="34" fill="url(#panel)"/>
<rect x="604" y="174" width="595" height="54" rx="14" fill="#F5F7F9" opacity=".13"/>
<circle cx="632" cy="201" r="8" fill="#EE7770"/><circle cx="659" cy="201" r="8" fill="#F5CE66"/><circle cx="686" cy="201" r="8" fill="#88C89B"/>
<image x="609" y="270" width="586" height="354" xlink:href="{menu}" filter="url(#shadow)"/>
'''))

render("app_store_02_timed_sessions", canvas(f'''
{brand(65, 55)}
<rect x="54" y="145" width="654" height="535" rx="34" fill="url(#panel)"/>
<rect x="80" y="174" width="602" height="54" rx="14" fill="#F5F7F9" opacity=".13"/>
<circle cx="108" cy="201" r="8" fill="#EE7770"/><circle cx="135" cy="201" r="8" fill="#F5CE66"/><circle cx="162" cy="201" r="8" fill="#88C89B"/>
<image x="89" y="270" width="586" height="354" xlink:href="{menu}" filter="url(#shadow)"/>
<text x="760" y="256" font-family="Helvetica Neue,Arial,sans-serif" font-size="57" font-weight="750" fill="#102D47">Set a timer.</text>
<text x="760" y="328" font-family="Helvetica Neue,Arial,sans-serif" font-size="57" font-weight="750" fill="#102D47">Stay focused.</text>
<text x="763" y="395" font-family="Helvetica Neue,Arial,sans-serif" font-size="23" fill="#486477">Choose a quick session from</text>
<text x="763" y="427" font-family="Helvetica Neue,Arial,sans-serif" font-size="23" fill="#486477">the real menu bar controls.</text>
<rect x="759" y="521" width="424" height="111" rx="27" fill="#DCEAF4"/>
<text x="789" y="569" font-family="Helvetica Neue,Arial,sans-serif" font-size="22" font-weight="650" fill="#194A69">1 · 2 · 5 · 10 minutes</text>
<text x="789" y="604" font-family="Helvetica Neue,Arial,sans-serif" font-size="18" fill="#486477">Or leave it on until you turn it off.</text>
'''))
