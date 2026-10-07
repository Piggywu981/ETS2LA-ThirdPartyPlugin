# Third-Party ETS2LA Plugins

A collection of third-party plugins for [ETS2LA](https://github.com/ETS2LA) — an open-source autonomous driving agent for Euro Truck Simulator 2 and American Truck Simulator.

## Plugins

| Plugin | Description |
|---|---|
| [AutoParking](https://github.com/Piggywu981/AutoParking) | Picks a parking spot on the 2D map, projects it onto the game screen as an AR overlay, then reverses the tractor in using gears, throttle, brake and steering. |
| [OvertakeAssistant](https://github.com/Piggywu981/OvertakeAssistant) | Coordinates overtaking by using the existing indicator lane-change flow. Looks for slower vehicles ahead and requests lane changes. |
| [SequentialAutoShift](https://github.com/Piggywu981/SequentialAutoShift) | Sequential gearbox auto shifting with a shift schedule interpolated across throttle travel, checked against the truck's gear ratios, and verified after the `gearup` / `geardown` pulse. |
| [SpeedLimitUnlocker](https://github.com/Piggywu981/SpeedLimitUnlocker) | Prevents the global ACC target speed from being reset to the road speed limit. |

## Getting Started

Clone this repository with all submodules:

```powershell
git clone --recurse-submodules https://github.com/Piggywu981/ETS2LA-ThirdPartyPlugin.git
```

If you already cloned without `--recurse-submodules`, run:

```powershell
git submodule update --init --recursive
```

Each plugin has its own build instructions in its respective README. The `build-and-deploy.ps1`
script at the repository root builds every plugin against a local ETS2LA install and copies the
resulting DLLs into the host's `Plugins` directory:

```powershell
.\build-and-deploy.ps1 -Ets2laRoot "D:\path\to\ETS2LA-win-release-Portable"
```

## License

Refer to each plugin's individual repository for license information.
