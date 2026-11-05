#!/usr/bin/env bash
# CC:Tweaked MCreator Plugin - Codespaces/Linux build script
# Usage: ./build.sh [Gradle tasks...]
# Example: ./build.sh clean jar --stacktrace
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MCREATOR_VERSION="${MCREATOR_VERSION:-2026.2.33518}"
BUILD_DEPS_DIR="${BUILD_DEPS_DIR:-${ROOT_DIR}/.build-deps}"
MCREATOR_DIR="${MCREATOR_SOURCE_DIR:-${BUILD_DEPS_DIR}/MCreator}"
GRADLE_TASKS=("$@")
if (("${#GRADLE_TASKS[@]}" == 0)); then
    GRADLE_TASKS=(clean jar)
fi

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

command -v java >/dev/null 2>&1 || fail "Java was not found. Install JDK 25 or use the supplied Codespaces environment."
command -v git >/dev/null 2>&1 || fail "Git was not found. Install Git and retry."

JAVA_VERSION="$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}')"
JAVA_MAJOR="${JAVA_VERSION%%.*}"
if [[ "$JAVA_MAJOR" == "1" ]]; then JAVA_MAJOR="$(printf '%s' "$JAVA_VERSION" | cut -d. -f2)"; fi
[[ "$JAVA_MAJOR" == "25" ]] || fail "JDK 25 is required for MCreator ${MCREATOR_VERSION}; detected Java ${JAVA_VERSION:-unknown}."

# Reuse the checkout only when it is exactly the requested MCreator release.
# Previously, checking only for gradlew/settings.gradle allowed an old checkout
# to be silently reused for a newer MCreator build.
if [[ -d "$MCREATOR_DIR" ]]; then
    ACTUAL_TAG=""
    if git -C "$MCREATOR_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        ACTUAL_TAG="$(git -C "$MCREATOR_DIR" describe --tags --exact-match HEAD 2>/dev/null || true)"
    fi

    if [[ "$ACTUAL_TAG" != "$MCREATOR_VERSION" ]]; then
        if [[ -n "${MCREATOR_SOURCE_DIR:-}" ]]; then
            fail "MCREATOR_SOURCE_DIR points to tag '${ACTUAL_TAG:-unknown}', but ${MCREATOR_VERSION} is required. Point it to the correct checkout."
        fi
        printf 'Existing MCreator checkout is %s; replacing it with %s...\n' "${ACTUAL_TAG:-unknown}" "$MCREATOR_VERSION"
        rm -rf -- "$MCREATOR_DIR"
    fi
fi

if [[ ! -f "${MCREATOR_DIR}/gradlew" || ! -f "${MCREATOR_DIR}/settings.gradle" ]]; then
    mkdir -p "$BUILD_DEPS_DIR"
    [[ ! -e "$MCREATOR_DIR" ]] || fail "${MCREATOR_DIR} exists but is not a valid MCreator source checkout."
    printf 'Downloading MCreator source %s...\n' "$MCREATOR_VERSION"
    git clone --depth 1 --branch "$MCREATOR_VERSION" https://github.com/MCreator/MCreator.git "$MCREATOR_DIR"
fi

ACTUAL_TAG="$(git -C "$MCREATOR_DIR" describe --tags --exact-match HEAD 2>/dev/null || true)"
[[ "$ACTUAL_TAG" == "$MCREATOR_VERSION" ]] || fail "Expected MCreator tag ${MCREATOR_VERSION}, but found '${ACTUAL_TAG:-unknown}'."

MCREATOR_SERIES="${MCREATOR_VERSION%.*}"
MCREATOR_CONF="${MCREATOR_DIR}/src/main/resources/mcreator.conf"
[[ -f "$MCREATOR_CONF" ]] || fail "Could not find MCreator version file: $MCREATOR_CONF"
grep -qx "mcreator=${MCREATOR_SERIES}" "$MCREATOR_CONF" || fail "MCreator checkout tag is ${ACTUAL_TAG}, but mcreator.conf does not identify it as ${MCREATOR_SERIES}."

[[ -f "${MCREATOR_DIR}/gradlew" ]] || fail "MCreator Gradle wrapper not found in ${MCREATOR_DIR}."
chmod +x "${MCREATOR_DIR}/gradlew"

printf '\nPreparing MCreator 2026.2 JCEF toolchain...\n'
"${MCREATOR_DIR}/gradlew" -p "$MCREATOR_DIR" downloadJDKLinux64 --no-daemon

printf '\nBuilding CC:Tweaked MCreator plugin against MCreator %s...\n' "$MCREATOR_VERSION"
cd "$ROOT_DIR"
"${MCREATOR_DIR}/gradlew" -p "$ROOT_DIR" "-Pmcreator_path=${MCREATOR_DIR}" --no-daemon "${GRADLE_TASKS[@]}"

PLUGIN_ZIP="${ROOT_DIR}/build/libs/cc-tweaked-mcreator-plugin.zip"
[[ -f "$PLUGIN_ZIP" ]] || fail "Gradle completed, but the expected plugin archive was not created: ${PLUGIN_ZIP}"
printf '\nBUILD SUCCESSFUL\nPlugin archive: %s\n' "$PLUGIN_ZIP"
