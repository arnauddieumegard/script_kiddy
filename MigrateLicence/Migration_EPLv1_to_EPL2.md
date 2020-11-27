# Migration eplv2

## Objective

Be compliant with: https://www.eclipse.org/projects/handbook/#legaldoc-plugins

In a nutshell:

```
eclipse
 ├── LICENSE - Text of the project license(s)
 ├── plugins
 │   ├── org.eclipse.core.runtime_3.13.0.v20170207-1030.jar - Plug-in packaged as a JAR
 │   │   ├── about.html - Standard _About_ file
 │   │   └── ...
 │   ├──org.apache.ant_1.10.1.v20170504-0840 - Third-party content packaged as a directory
 │   │   ├── about.html
 │   │   ├── about_files - Licenses and notices related to the content
 │   │   │   ├── DOM-LICENSE.html
 │   │   │   ├── LICENSE
 │   │   │   ├── NOTICE
 │   │   │   ├── SAX-LICENSE.html
 │   │   │   └── APACHE-2.0.txt
 │   │   └── ...
 │   └── ...
 └── ...
```

``` 
eclipse
 ├── features
 │   ├── org.eclipse.rcp_4.7.1.v20171009-0410 - Feature directory
 │   │   ├── license.html - Feature License (SUA)
 │   │   ├── epl-2.0.html - The project’s primary licenses(s) referenced by the SUA/Feature License
 │   │   ├── feature.properties - Feature Update License (SUA) in `license` property
 │   │   └── ...
 │   └── ...
 ├── plugins
 │   ├── org.eclipse.rcp_4.7.1.v20171009-0410.jar - Plug-in packaged as a directory
 │   │   ├── about.properties - Feature Blurb in `blurb` property
 │   │   └── ...
 │   └── ...
 └── ...
```
 
Standard header:

```
/********************************************************************************
 * Copyright (c) {year} {owner}[ and others]
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   {name} - initial API and implementation
 ********************************************************************************/
```

## Starting point: All occurences

```
find . -type f -iname "*.*" | awk '{printf("\"%s\"\n",$0)}' | xargs grep -l "epl-v1"
```
 
### Docgen

Bug: 568919
[568919] 

### Introspector

Bug: 568997

### Capella-Studio

Bug: 569054

### Kitalpha

Bug: 569166

## At the end:

Check that "Eclipse Public License v1.0" and "epl-v10" cannot be found on the repository

## Update html files

### Replace epl-v10.html with epl-v2.0.html

Copy attached epl-2.0.html file into execution folder

```
find . -iname "epl-v10.html" -printf "cp epl-2.0.html \"%Premove\"; rm \"%P\"\n" | sed 's/epl-v10.htmlremove/epl-2.0.html/' | awk '{system($0)}'
```

### Replace license.html content files with new licensev2.html file content

Copy licensev2.html

license.html must contain: <title>Eclipse Foundation Software User Agreement</title>

```
find . -iname "license.html" -printf "\"%P\"" -exec grep -q '<title>Eclipse Foundation Software User Agreement</title>' {} \; -exec cp licensev2.html {} \;
```

### Replace about.html content files with new aboutv2.html file content

Copy aboutv2.html

```
find . -iname "about.html" -printf "\"%P\"" -exec grep -q 'Eclipse Public License Version 1.0' {} \; -exec cp aboutv2.html {} \;
```

### Commit message
```
[XXXX] Update html files

- epl-v10.html -> epl-2.0.html
- license.html
- about.html
```

## Copy LICENSE.md

Copy LICENSE.md at project root

### Commit message

```
[XXXX] Add LICENSE.md
```

## *.properties

### headers

replace:
```
^((\s)*)#((\s)*)All rights reserved.((\s)*)This program and the accompanying materials(\r)?\n((\s)*)#((\s)*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)#((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)#((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1#\3This program and the accompanying materials are made available under the\7\n\1#\3terms of the Eclipse Public License 2.0 which is available at\7\n\1#\3http://www.eclipse.org/legal/epl-2.0\7\n\1#\7\n\1#\3SPDX-License-Identifier: EPL-2.0
```

and

replace:
```
^((\s)*)#((\s)*)\*((\s)*)All rights reserved.((\s)*)This program and the accompanying materials(\r)?\n((\s)*)#((\s)*)\*((\s)*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)#((\s)*)\*((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)#((\s)*)\*((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1#\3\*\5This program and the accompanying materials are made available under the\9\n\1#\3\*\5terms of the Eclipse Public License 2.0 which is available at\9\n\1#\3\*\5http://www.eclipse.org/legal/epl-2.0\9\n\1#\9\n\1#\3\*\5SPDX-License-Identifier: EPL-2.0
```

#### to test:

replace:
```
^(.*)All rights reserved.(.*)This program and the accompanying materials(\r)?\n(.*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n(.*)which accompanies this distribution, and is available at(\r)?\n(.*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1This program and the accompanying materials are made available under the\3\n\1terms of the Eclipse Public License 2.0 which is available at\3\n\1http://www.eclipse.org/legal/epl-2.0\3\n\3\n\1SPDX-License-Identifier: EPL-2.0
```

### build.properties

replace:
```
^(.*)epl-v10\.html(.*)
```

with:
```
\1epl-2.0\.html\2
```

#### All build.properties with feature.xml and no "epl.*html"

The trick for not somethign in file is "-L" switch
```
find . -type f -iname 'build.properties' -printf "\"%P\"\n" | xargs grep -l "feature\.xml" | awk '{printf "\"%s\"\n", $0}' | xargs grep -l -L "epl.*html"
```

##### Add epl-2.0.html at the end:

perl -0777 -i.bak -pe 's/((.*(\r)?(\n))*)((.*)(\r)?(\n))/$1$6,\\$7$8epl-2.0.html$7$8/gm' "architecture description/core/features/org.polarsys.kitalpha.ad.integration.amalgam.feature/build.properties"

### feature.properties

#### copyright value

replace:
```
^((\s)*)All rights reserved. This program and the accompanying materials\\n\\(\r)?\n((\s)*)are made available under the terms of the Eclipse Public License v1.0\\n\\(\r)?\n((\s)*)which accompanies this distribution, and is available at\\n\\(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\\n\\\3\n\1This program and the accompanying materials are made available under the\\n\\\3\n\1terms of the Eclipse Public License 2.0 which is available at\\n\\\3\n\1http://www.eclipse.org/legal/epl-2.0\\n\\\3\n\\n\\\3\n\1SPDX-License-Identifier: EPL-2.0
```

#### license

Copy feature.properties.license.raw to root folder
Encode feature.properties.license.raw line endings to the same line endings as the feature.properties files

```
find . -type f -iname 'feature.properties' -exec perl -0777 -i.bak -pe 'BEGIN {local $/; open(my $f, "<", "feature.properties.license.raw"); $d = <$f>}; s/^license=\\(\r)?\n(.*(\r)?(\n)?)*########### end of license property ##########################################/$d/gm' "{}" +;
```

### Commit message

```
[XXXX] Update properties files

- Copyright headers values on build.properties, bundle.properties, feature.properties and messages.properties
- Copyright value in feature.properties
- License value in feature.properties
```

## *.xml, *.fcore, *.exsd, *.genmodel

find . -type f \( -iname '*.xml' -o -iname '*.fcore' -o -iname '*.exsd' -o -iname '*.genmodel' \) | awk '{printf "\"%s\"\n", $0}' | xargs grep "epl-v10"

### header

replace:
```
^((\s)*)All rights reserved. This program and the accompanying materials(\r)?\n((\s)*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1This program and the accompanying materials are made available under the\3\n\1terms of the Eclipse Public License 2.0 which is available at\3\n\1http://www.eclipse.org/legal/epl-2.0\3\n\3\n\1SPDX-License-Identifier: EPL-2.0
```

### pom.xml

replace:
```
^((\s)*)<name>Eclipse Public License v1.0</name>(\r)?\n((\s)*)<comments>(\r)?\n((\s)*)All rights reserved.(\r)?\n(\r)?\n((\s)*)This program and the accompanying materials are made(\r)?\n((\s)*)available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.htm(\r)?\n((\s)*)</comments>
```

or

```
^((\s)*)<name>Eclipse Public License v1.0</name>(\r)?\n((\s)*)<comments>(\r)?\n((\s)*)All rights reserved.(\r)?\n(\r)?\n((\s)*)This program and the accompanying materials are made available under the(\r)?\n((\s)*)terms of the Eclipse Public License v1.0 which accompanies this(\r)?\n((\s)*)distribution, and is available at(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.htm(\r)?\n((\s)*)</comments>
```

with:
```
\1<name>Eclipse Public License v2.0</name>\3\n\4<comments>\3\n\7This program and the accompanying materials are made available under the\3\n\7terms of the Eclipse Public License 2.0 which is available at\3\n\7http://www.eclipse.org/legal/epl-2.0\3\n\3\n\7SPDX-License-Identifier: EPL-2.0\3\n\4</comments>
```

### Commit message

```
[XXXX] Update xml files

- Copyright
- exsd files content
- fcore files content
(- license in pom.xml)???
```

## *.java, *.css, *.targetplatform, *.pt, *.xtend

### all java files that are not generated:

```
find . -type f -not -wholename '**/generated/**.java' -iname '*.java' | awk '{printf "\"%s\"\n", $0}' | xargs grep -l -L "epl.*html"
```

replace:
```
^((\s)*)\*((\s)*)All rights reserved.((\s)*)This program and the accompanying materials(\r)?\n((\s)*)\*((\s)*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)\*((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)\*((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

```
^(.*)All rights reserved.((\s)*)This program and the accompanying materials((\s)*)(\r)?\n(.*)are made available under the terms of the Eclipse Public License v1.0((\s)*)(\r)?\n(.*)which accompanies this distribution, and is available at((\s)*)(\r)?\n(.*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1\*\3This program and the accompanying materials are made available under the\5\n\1\*\3terms of the Eclipse Public License 2.0 which is available at\5\n\1\*\3http://www.eclipse.org/legal/epl-2.0\5\n\1\*\5\n\1\*\3SPDX-License-Identifier: EPL-2.0
```

```
\1This program and the accompanying materials are made available under the\6\n\1terms of the Eclipse Public License 2.0 which is available at\6\n\1http://www.eclipse.org/legal/epl-2.0\6\n\1\6\n\1SPDX-License-Identifier: EPL-2.0
```

### Commit message

```
[XXXX] Update source files

- Java copyrights
- CSS copyrights
- targetplatform copyrights
- EGF Patterns copyrights
- EGF Generated files update
- XTend files sources and generated files
```

## EMF generation content

### string content in *.java

replace:
```
All rights reserved. This program and the accompanying materials(\\r)?\\n((\s)*)are made available under the terms of the Eclipse Public License v1.0(\\r)?\\n((\s)*)which accompanies this distribution, and is available at(\\r)?\\n((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
This program and the accompanying materials are made available under the\1\\n\3terms of the Eclipse Public License 2.0 which is available at\1\\n\3http://www.eclipse.org/legal/epl-2.0\1\\n\1\\n\3SPDX-License-Identifier: EPL-2.0
```

### *.genmodel

replace:
```
All rights reserved. This program and the accompanying materials(&#xD;)?&#xA;((\s)*)are made available under the terms of the Eclipse Public License v1.0(&#xD;)?&#xA;((\s)*)which accompanies this distribution, and is available at(&#xD;)?&#xA;((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
This program and the accompanying materials are made available under the\1&#xA;\3terms of the Eclipse Public License 2.0 which is available at\1&#xA;\3http://www.eclipse.org/legal/epl-2.0\1&#xA;\1&#xA;\3SPDX-License-Identifier: EPL-2.0
```

### license.txt

replace:
```
^These followings icons are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
This program and the accompanying materials are made available under the\1\n\3terms of the Eclipse Public License 2.0 which is available at\1\n\3http://www.eclipse.org/legal/epl-2.0\1\n\1\n\3SPDX-License-Identifier: EPL-2.0
```

### Commit message

```
[XXXX] EMF source and generated files

- Java
- genmodel
- icons txt files
```

## Product and scripts

### *.txt

```
^(.*)All rights reserved.((\s)*)This program and the accompanying materials((\s)*)(\r)?\n(.*)are made available under the terms of the Eclipse Public License v1.0((\s)*)(\r)?\n(.*)which accompanies this distribution, and is available at((\s)*)(\r)?\n(.*)http://www.eclipse.org/legal/epl-v10.html
```

```
\1This program and the accompanying materials are made available under the\6\n\1terms of the Eclipse Public License 2.0 which is available at\6\n\1http://www.eclipse.org/legal/epl-2.0\6\n\1\6\n\1SPDX-License-Identifier: EPL-2.0
```

### Headers

replace:
```
^((\s)*)#((\s)*)All rights reserved. This program and the accompanying materials(\r)?\n((\s)*)#((\s)*)are made available under the terms of the Eclipse Public License v1.0(\r)?\n((\s)*)#((\s)*)which accompanies this distribution, and is available at(\r)?\n((\s)*)#((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1#\3This program and the accompanying materials are made available under the\5\n\1#\3terms of the Eclipse Public License 2.0 which is available at\5\n\1#\3http://www.eclipse.org/legal/epl-2.0\5\n\1#\5\n\1#\3SPDX-License-Identifier: EPL-2.0
```

### Content

replace:
```
^((\s)*)All rights reserved.((\s)*)This program and the accompanying materials\\n\\(\r)?\n((\s)*)are made available under the terms of the Eclipse Public License v1.0\\n\\(\r)?\n((\s)*)which accompanies this distribution, and is available at\\n\\(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.html
```

with:
```
\1This program and the accompanying materials are made available under the\\n\\\5\n\1terms of the Eclipse Public License 2.0 which is available at\\n\\\5\n\1http://www.eclipse.org/legal/epl-2.0\\n\\\5\n\\n\\\5\n\1SPDX-License-Identifier: EPL-2.0
```

and

replace:
```
^((\s)*)Eclipse Public License v1.0(\r)?\n(\r)?\n((\s)*)All rights reserved.(\r)?\n(\r)?\n((\s)*)This program and the accompanying materials are made available under the(\r)?\n((\s)*)terms of the Eclipse Public License v1.0 which accompanies this(\r)?\n((\s)*)distribution, and is available at(\r)?\n((\s)*)http://www.eclipse.org/legal/epl-v10.htm
```

with:
```
Eclipse Public License 2.0\3\n\3\n\5This program and the accompanying materials are made available under the\3\n\5terms of the Eclipse Public License 2.0 which is available at\3\n\5http://www.eclipse.org/legal/epl-2.0\3\n\3\n\5SPDX-License-Identifier: EPL-2.0
```

### Commit message

```
[XXXX] Update product and scripts
```

## Update copyright year

list all files modified between HEAD and commit:
```
git diff-tree --no-commit-id --name-only -r HEAD..d33fd05 | awk '{printf "\"%s\"\n", $0}'
```

// Update XXXX, XXXX years to XXXX, 2020
```
git diff-tree --no-commit-id --name-only -r HEAD..d33fd05 | awk '{printf "\"%s\"\n", $0}' | xargs perl -0777 -i.bak -pe 's/^(.*)Copyright \(c\) (\d{4}), \d{4} (.*)$/\1Copyright (c) \2, 2020 \3/gm'
```

```
git diff-tree --no-commit-id --name-only -r HEAD..d33fd05 | awk '{printf "\"%s\"\n", $0}' | xargs perl -0777 -i.bak -pe 's/^(.*)Copyright \(c\) (\d{4})-\d{4} (.*)$/\1Copyright (c) \2-2020 \3/gm'
```

// Update XXXX year to XXXX, 2020
```
git diff-tree --no-commit-id --name-only -r HEAD..d33fd05 | awk '{printf "\"%s\"\n", $0}' | xargs perl -0777 -i.bak -pe 's/^(.*)Copyright \(c\) (?<test>(?!2020)\d{4})? (.*)$/\1Copyright (c) \2, 2020 \3/gm'
```

### Commit message

```
[XXXX] Update copyright year on all modified files
```

## Clean all .bak files

```
find . -type f -iname '*.bak' | awk '{printf "\"%s\"\n", $0}' | xargs rm
```

## Revert modified files since last commit

```
git diff --name-only | xargs git checkout --
```

## All generated files modifications

```
git diff-tree --no-commit-id --name-only -r HEAD..75809d2 | awk '{printf "\"%s\"\n", $0}' | grep ".*\/generated\/.*" | xargs git diff HEAD..75809d2
```

## Find all zip files that are on the repository

```
find . -iname "*.zip" -exec git ls-files "{}" \;
```

## Projets:

### Kitalpha Addons

133 "Eclipse Public License v1.0" and 178 "epl-v10"

