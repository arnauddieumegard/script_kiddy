#!/bin/sh

# Largely inspired from https://ci.eclipse.org/oomph/job/repository-analyzer/ configuration

# Get your binary from https://download.eclipse.org/oomph/products/latest/
# Extract it

export OUTPUT=".\reports"

eclipse-inst-win64/eclipse-inst.exe \
  -application org.eclipse.oomph.p2.core.RepositoryIntegrityAnalyzer \
  -consoleLog \
  -noSplash \
  -o $OUTPUT \
  -v \
  -p $OUTPUT \
  "https://download.eclipse.org/kitalpha/updates/nightly/runtime/PR-84" \
  "https://download.eclipse.org/kitalpha/updates/nightly/runtimecore/PR-84" \
  "https://download.eclipse.org/kitalpha/updates/nightly/sdk/PR-84" \
  "https://download.eclipse.org/kitalpha/updates/nightly/component/PR-84" \
  "https://download.eclipse.org/capella/capellastudio/updates/nightly/master" \
  "https://download.eclipse.org/capella/addons/xhtmldocgen/updates/nightly/master/" \
  "https://download.eclipse.org/capella/addons/basicprice/updates/nightly/master/" \
  "https://download.eclipse.org/capella/addons/basicmass/updates/nightly/master/" \
  "https://download.eclipse.org/capella/addons/basicperfo/updates/nightly/master/" \
  "https://download.eclipse.org/capella/addons/xhtmldocgen/updates/nightly/master/" \
  "https://download.eclipse.org/kitalpha/addons/introspector/nightly/master/" \
  -vmargs \
    -Dfile.encoding=UTF-8 \
    -Dorg.eclipse.emf.ecore.plugin.EcorePlugin.doNotLoadResourcesPlugin=true \
    -Xmx8g \
  2>&1 | tee.exe log