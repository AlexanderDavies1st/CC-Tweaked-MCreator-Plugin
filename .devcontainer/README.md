# GitHub Codespaces

Open this repository in GitHub Codespaces. The container provides JDK 25 and Git, as required by MCreator 2026.2.

Run the build from the repository root:

```bash
./build.sh
```

The first run downloads the matching MCreator source tag (`2026.2.33518`) into `.build-deps/MCreator`, downloads MCreator's JCEF-enabled JetBrains Runtime, and then builds this plugin. Later runs reuse both downloads.

The resulting plugin archive is:

```text
build/libs/cc-tweaked-mcreator-plugin.zip
```

To build with another MCreator source checkout, set `MCREATOR_SOURCE_DIR`:

```bash
MCREATOR_SOURCE_DIR=/workspaces/MCreator ./build.sh
```

The source checkout must match MCreator 2026.2 and contain `gradlew` and `settings.gradle`.
