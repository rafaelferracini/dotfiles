#!/usr/bin/env python3
import os
import sys
import subprocess
from pathlib import Path

def main():
    if len(sys.argv) < 2:
        print("Uso: inkscape-figures.py <caminho_do_arquivo_tex>")
        sys.exit(1)

    tex_path = Path(sys.argv[1]).resolve()
    root_dir = tex_path.parent
    figures_dir = root_dir / "figures"
    figures_dir.mkdir(exist_ok=True)

    # Pergunta o nome da figura via Rofi
    rofi = subprocess.run(
        ["rofi", "-dmenu", "-p", "Nome da figura:"],
        input="", text=True, capture_output=True
    )
    title = rofi.stdout.strip()
    if not title:
        return

    filename = title.lower().replace(" ", "-") + ".svg"
    file_path = figures_dir / filename

    # Template básico para novas figuras do Inkscape
    if not file_path.exists():
        template = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="240mm" height="120mm" viewBox="0 0 240 120" version="1.1" id="svg1" xmlns="http://www.w3.org/2000/svg">
  <defs id="defs1" />
  <g id="layer1" />
</svg>
'''
        file_path.write_text(template)

    # Copia o código LaTeX da figura para a área de transferência
    latex_code = f"\\incfig{{{title.lower().replace(' ', '-')}}}"
    subprocess.run(["xclip", "-selection", "clipboard"], input=latex_code, text=True)

    # Abre o Inkscape no plano de fundo
    subprocess.Popen(["inkscape", str(file_path)])

if __name__ == "__main__":
    main()
