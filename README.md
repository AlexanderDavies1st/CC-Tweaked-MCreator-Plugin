# CC: Tweaked Integration for MCreator

**Plugin version:** 0.1.0  
**Target:** MCreator 2026.2, NeoForge 1.21.8 generator, Java 25  
**CC: Tweaked API compile dependency:** `cc-tweaked:cc-tweaked-1.21.8-common-api:1.116.1`

This project adds MCreator mod elements for creating Lua content that is included in CC: Tweaked's CraftOS ROM, plus a Java-backed `ILuaAPI` element.

See `README-full.md` for detailed documentation, the MCreator 2026.2 / NeoForge 1.21.8 compatibility note, and build instructions.

## Build in GitHub Codespaces

Rebuild the Codespaces container after pulling the latest changes so it uses JDK 25. Then run:

```bash
./build.sh
```

The script downloads MCreator source tag `2026.2.33518`, prepares its JCEF-enabled Java runtime, and builds the plugin. Output: `build/libs/cc-tweaked-mcreator-plugin.zip`.

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
