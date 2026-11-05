# CC: Tweaked Integration for MCreator

**Plugin version:** 0.1.0  
**Target:** MCreator 2026.2, NeoForge 1.21.8 generator, Java 25  
**CC: Tweaked API compile dependency:** `cc-tweaked:cc-tweaked-1.21.8-common-api:1.116.1`

This project adds MCreator mod elements for creating Lua content that is included in CC: Tweaked's CraftOS ROM, plus a Java-backed `ILuaAPI` element.

## What it adds

| MCreator element | Generated resource / class | Purpose |
|---|---|---|
| CC:T Lua Program | `data/computercraft/lua/rom/programs/<name>.lua` | Adds a shell command/program. |
| CC:T Lua Module | `data/computercraft/lua/rom/modules/main/<name>.lua` | Adds a module loadable with `require("<name>")`. |
| CC:T Lua API | `data/computercraft/lua/rom/apis/<name>.lua` | Adds an API loaded by `os.loadAPI` during startup. |
| CC:T HTTP API | `data/computercraft/lua/rom/apis/http/<name>.lua` | Adds an HTTP-enabled-computers API. |
| CC:T Turtle API | `data/computercraft/lua/rom/apis/turtle/<name>.lua` | Adds an API to turtles. |
| CC:T Pocket API | `data/computercraft/lua/rom/apis/pocket/<name>.lua` | Adds an API to pocket computers. |
| CC:T Command API | `data/computercraft/lua/rom/apis/command/<name>.lua` | Adds an API to command computers. |
| CC:T Startup Script | `data/computercraft/lua/rom/autorun/<name>.lua` | Runs the Lua file when a computer starts. |
| CC:T Help Entry | `data/computercraft/lua/rom/help/<name>.md` | Adds a CraftOS help page. |
| CC:T Java Lua API | `cctweaked/<Name>CCTLuaAPI.java` | Generates and automatically registers a Java `ILuaAPI`. |

The Lua editors write the content as raw text. No Lua code is evaluated by MCreator during generation.

## Java-backed Lua APIs

Create a **CC:T Java Lua API** element. The element editor supports:
- A module name, such as `examplemod.tools`, exposed through `require("examplemod.tools")`.
- Optional comma-separated global names, such as `example_tools, tools`.
- Additional Java imports.
- Java class members and `@LuaFunction` methods.

The generated class registers itself during NeoForge's `FMLCommonSetupEvent`, using `event.enqueueWork` and `ComputerCraftAPI.registerAPIFactory`. The API is exposed to all computers; add a component check in the generated factory if the API should only be exposed to a particular computer type.

Example method body:

```java
@LuaFunction
public final String greet(String playerName) {
    return "Hello, " + playerName + "!";
}
```

## Enabling the CC: Tweaked API dependency

In the MCreator workspace, open **Workspace settings → External APIs** and enable **CC: Tweaked API** before using the Java Lua API element. The API YAML adds this compile-only dependency:

```gradle
repositories {
    maven {
        name = "CC Tweaked Maven"
        url = "https://maven.squiddev.cc"
        content { includeGroup("cc.tweaked") }
    }
}

dependencies {
    compileOnly("cc.tweaked:cc-tweaked-1.21.8-common-api:1.116.1")
}
```

The dependency is compile-only. CC: Tweaked itself must still be installed in the Minecraft instance/modpack at runtime.

## MCreator 2026.2 and Minecraft 1.21.8

MCreator 2026.2's built-in Java generators target NeoForge 26.1.2 and 1.21.1; the built-in 1.21.8 generator was removed. This plugin's generator definitions remain under `neoforge-1.21.8` because the bundled CC: Tweaked API dependency targets Minecraft 1.21.8.

To use these elements in a 1.21.8 workspace on MCreator 2026.2, install a compatible third-party NeoForge 1.21.8 generator for MCreator 2026.2 first. The CC:T plugin does not itself add a Minecraft generator.

## Building in GitHub Codespaces

1. Open the repository in GitHub Codespaces. The dev container provides JDK 25.
2. In the Codespaces terminal, run:

   ```bash
   ./build.sh
   ```

3. On the first run, the script clones MCreator source tag `2026.2.33518` into `.build-deps/MCreator`.
4. It downloads MCreator's JCEF-enabled JetBrains Runtime before compiling MCreator's source, then builds the plugin.
5. The resulting plugin archive is `build/libs/cc-tweaked-mcreator-plugin.zip`.

The same script works on Linux with Git and JDK 25 installed. To use a pre-existing MCreator source checkout, set `MCREATOR_SOURCE_DIR` before running the script.

The `.devcontainer` folder configures JDK 25 and Java/Gradle VS Code extensions. The GitHub Actions workflow runs the same build on pushes, pull requests, and manual dispatches, then publishes the ZIP as a workflow artifact.

## CC: Tweaked ROM rules

CC: Tweaked merges resources from the `computercraft` resource namespace into its ROM. Generated Lua resource files use the `data/computercraft/lua/rom/...` namespace. Use lower-case registry names for data-pack paths.

## Compatibility notes

- Plugin metadata targets MCreator 2026.2.
- Generator definitions are supplied for `neoforge-1.21.8` only.
- CC: Tweaked's 1.21.8 API version used here is 1.116.1.
- MCreator 2026.2 requires Java 25 for development builds.
- The plugin does not bundle CC: Tweaked or copy any CC: Tweaked implementation code.
- This first version does not provide visual Blockly procedure blocks for invoking CC:T methods. It focuses on ROM resources and generated Java `ILuaAPI` classes.

## References

- CC: Tweaked data-pack / ROM reference: https://www.tweaked.cc/reference/data_pack.html
- CC: Tweaked source: https://github.com/cc-tweaked/cc-tweaked
- CC: Tweaked API documentation: https://www.tweaked.cc/mc-1.21.x/javadoc/
- MCreator plugin development: https://mcreator.net/wiki/developing-mcreator-plugins
- MCreator custom API files: https://mcreator.net/wiki/creating-apis

## Build status

This is an initial development release. A full compilation against MCreator 2026.2 and an in-MCreator installation test are still required.
