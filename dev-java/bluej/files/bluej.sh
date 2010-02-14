#!/bin/sh
CP="/usr/share/bluej/lib/bluej.jar:`java-config --tools`"
`java-config --java` -cp "${CP}" bluej.Boot null $*
