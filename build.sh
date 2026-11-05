#!/usr/bin/env bash
# CC:Tweaked MCreator Plugin - Codespaces/Linux build script
# Usage: ./build.sh [Gradle tasks...]
# Example: ./build.sh clean jar
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MCREATOR_VERSION="${MCREATOR_VERSION:-2026.1.14619}"
BUILD_DEPS_DIR="${BUILD_DEPS_DIR:-${ROOT_DIR}/.build-deps}"
MCREATOR_DIR="${MCREATOR_SOURCE_DIR:-${BUILD_DEPS_DIR}/MCreator}"
GRADLE_TASKS=("$@")
if (("${#GRADLE_TASKS[@]}" == 0)); then
    GRADLE_TASKS=(clean jar)
fi

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

command -v java >/dev/null 2>&1 || fail "Java was not found. Open this project in the supplied Codespaces environment or install JDK 21."
command -v git >/dev/null 2>&1 || fail "Git was not found. Install Git and retry."

JAVA_VERSION="$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}')"
JAVA_MAJOR="${JAVA_VERSION%%.*}"
if [[ "$JAVA_MAJOR" == "1" ]]; then JAVA_MAJOR="$(printf '%s' "$JAVA_VERSION" | cut -d. -f2)"; fi
[[ "$JAVA_MAJOR" == "21" ]] || fail "JDK 21 is required for MCreator ${MCREATOR_VERSION}; detected Java ${JAVA_VERSION:-unknown}."

if [[ ! -f "${MCREATOR_DIR}/gradlew" || ! -f "${MCREATOR_DIR}/settings.gradle" ]]; then
    mkdir -p "$BUILD_DEPS_DIR"
    if [[ -e "$MCREATOR_DIR" ]]; then
        fail "${MCREATOR_DIR} exists but is not an MCreator source checkout. Remove it or set MCREATOR_SOURCE_DIR to a valid checkout."
    fi
    printf 'Downloading MCreator source %s (first build only)...\n' "$MCREATOR_VERSION"
    git clone --depth 1 --branch "$MCREATOR_VERSION" https://github.com/MCreator/MCreator.git "$MCREATOR_DIR"
fi

[[ -f "${MCREATOR_DIR}/gradlew" ]] || fail "MCreator Gradle wrapper not found in ${MCREATOR_DIR}."
chmod +x "${MCREATOR_DIR}/gradlew"

printf '\nBuilding CC:Tweaked MCreator plugin against MCreator %s...\n' "$MCREATOR_VERSION"
cd "$ROOT_DIR"
"${MCREATOR_DIR}/gradlew" -p "$ROOT_DIR" "-Pmcreator_path=${MCREATOR_DIR}" --no-daemon "${GRADLE_TASKS[@]}"

PLUGIN_ZIP="${ROOT_DIR}/build/libs/cc-tweaked-mcreator-plugin.zip"
[[ -f "$PLUGIN_ZIP" ]] || fail "Gradle completed, but the expected plugin archive was not created: ${PLUGIN_ZIP}"
printf '\nBUILD SUCCESSFUL\nPlugin archive: %s\n' "$PLUGIN_ZIP"
