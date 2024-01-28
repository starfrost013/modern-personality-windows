# modern:personality - Windows Decompilation

This project attempts to reverse engineer Microsoft Windows 1.x entirely to recompliable code, as well as research it and Multitasking MS-DOS 4.0 ("MT-DOS"). 

The research repository is located here: [Research Repo](https://github.com/starfrost013/modernpersonality)
The runtime used to run the legacy toolchain on modern operating systems is here:(https://github.com/starfrost013/modern-personality-runtime)

## Notes
Still in a very early state, not rebuildable yet. The intention is to initially recreate Windows 1.03, compiled as a debug build (checked was not used until Windows NT), based on symbolic debugging inforamation and filenames found in slack space of final production builds of the OS, one "module" at a time, and slowly slipstream each component onto the OS more and more until the operating system has been entirely reversed.

## Progress
| Component | Purpose 
| KERNEL | Debugging and code documentation in progress. Not recompliable yet. |
| Core drivers (mouse, keyboard, system timer, serial, etc) | Debugging and code documentation in progress. Not recompliable yet. |
| Display drivers | Reverse engineering in progress. (no symbols available for this component). |
| GDI | Early exploration. |
| USER | Early exploration. |
| Fonts (NE containers with FNTv1 resources) | Windows 3.0 FNTv2 already documented. |
| WINOLDAP | Early exploration |
| WIN.COM/*LGO* (fast-boot loader and boot screen) | Early exploration. |
| WINOLDAP Grabbers | Not started. |
| MSDOS, MSDOSD (Shell) | Not started. |
| SETUP | Not started. |
| Apps | Not started. Cardfile was provided in source code form in Windows 2.11 OAK, but most likely not licenseable. |

## Toolchain
Tools required for building:
| Tool | Purpose |
| Microsoft Macro Assembler 4.0 | Assembly parts of kernel (90%) |
| Microsoft C 4.0 | Most of GDI and USER |
| Windows SDK, version 1.03 | Headers and libraries, provides debug symbols |
| IDA | Time Wasted Debugging |

