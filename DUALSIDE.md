# OpenBoardView DualSide

A fork of [OpenBoardView](https://github.com/OpenBoardView/OpenBoardView) 10.0.0 that adds a **Dual-Side View**: the top and bottom of the board are shown at the same time, so you can trace connections between sides without flipping the board.

## Dual-Side View

Toggle it with **B**, the **Dual-Side** toolbar button, or **View → Dual-Side View**.

- Both sides are drawn in one plane at the same scale. The bottom side is mirrored about a horizontal axis just below the board, so each point keeps its X position on both copies.
- Zoom, pan and rotate work normally across both sides.
- Clicking on a copy makes that side active. Selection, tooltips and annotations work on both.
- When you select a pin or a part:
  - **Cyan:** pins on the opposite side that share a net, with a guide line and a `PART.pin  NET` label. Ground nets are skipped.
  - **Orange:** parts on the opposite side that sit under the selected footprint, such as decoupling capacitors under an IC. These are possible physical connections.

## Other changes

- The macOS bundle declares the board file types (`.brd`, `.bdv`, `.bv`, `.bvr`, `.asc`, `.fz`, `.cad`, `.cae`, `.cst`, `.pcb`), so you can open a file by double-clicking it.
- `install-macos.sh` builds the app and installs it to `/Applications/OpenBoardView DualSide.app`. It needs Homebrew `cmake`, `pkg-config` and `sdl2`. The script also bundles SDL3, which Homebrew's `sdl2-compat` loads at runtime.

## License

MIT, same as upstream. See [LICENSE](LICENSE).
