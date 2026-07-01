# Third-Party ETS2LA Plugins

A collection of third-party plugins for [ETS2LA](https://github.com/ETS2LA) — an open-source autonomous driving agent for Euro Truck Simulator 2 and American Truck Simulator.

## Plugins

| Plugin | Description |
|---|---|
| [OvertakeAssistant](https://github.com/Piggywu981/OvertakeAssistant) | Coordinates overtaking by using the existing indicator lane-change flow. Looks for slower vehicles ahead and requests lane changes. |
| [SequentialAutoShift](https://github.com/Piggywu981/SequentialAutoShift) | Conservative sequential gearbox auto shifting that reads telemetry and sends `gearup` / `geardown` control pulses. |
| [SpeedLimitUnlocker](https://github.com/Piggywu981/SpeedLimitUnlocker) | Prevents the global ACC target speed from being reset to the road speed limit. |

## Getting Started

Clone this repository with all submodules:

```powershell
git clone --recurse-submodules https://github.com/Piggywu981/ThirdPartyPlugin.git
```

If you already cloned without `--recurse-submodules`, run:

```powershell
git submodule update --init --recursive
```

Each plugin has its own build instructions in its respective README.

## License

Refer to each plugin's individual repository for license information.
