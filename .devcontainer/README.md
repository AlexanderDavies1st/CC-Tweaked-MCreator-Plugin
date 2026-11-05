# GitHub Codespaces

Open this repository in a Codespace. The container provides JDK 21 and Git.

Run the build from the repository root:

```bash
./build.sh
```

The first run downloads the matching MCreator source tag (`2026.1.14619`) into `.build-deps/MCreator`, then runs the plugin Gradle build. Later runs reuse that checkout. The resulting installable archive is:

```text
build/libs/cc-tweaked-mcreator-plugin.zip
```

To build with another MCreator source checkout, set `MCREATOR_SOURCE_DIR`:

```bash
MCREATOR_SOURCE_DIR=/workspaces/MCreator ./build.sh
```

The source checkout must match the plugin's target MCreator version and contain `gradlew` and `settings.gradle`.
