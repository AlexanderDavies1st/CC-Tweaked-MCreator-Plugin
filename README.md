# CC: Tweaked Integration for MCreator

**Plugin version:** 0.1.0  
**Target:** MCreator 2026.1, NeoForge 1.21.8, Java 21  
**CC: Tweaked API compile dependency:** `cc-tweaked:cc-tweaked-1.21.8-common-api:1.116.1`

This project adds MCreator mod elements for creating Lua content that is included in CC: Tweaked's CraftOS ROM, plus a Java-backed `ILuaAPI` element.

See the repository source and build instructions. This is an initial development release; it has not yet been verified by a complete MCreator compilation.

## Build in GitHub Codespaces

Open the repository in Codespaces, then run:

```bash
./build.sh
```

The script downloads the matching MCreator source checkout and builds the plugin with JDK 21. Output: `build/libs/cc-tweaked-mcreator-plugin.zip`.

## Supported elements

- Lua Program
- Lua Module
- Lua API
- HTTP API
- Turtle API
- Pocket API
- Command API
- Startup Script
- Help Entry
- Java Lua API

See `README-full.md` for detailed documentation and compatibility notes.
