#!/bin/sh

# Update this with the JAR file to be installed into Maven for version 7.6.0
JPL_JAR=/usr/local/swipl-git/lib/swipl/lib/jpl.jar 
VERSION=7.6.0

mvn install:install-file -o -Dfile=$JPL_JAR -DgroupId=com.github.SWI-Prolog -DartifactId=packages-jpl -Dversion=$VERSION -Dpackaging=jar

