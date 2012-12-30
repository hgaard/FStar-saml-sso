#!/bin/bash 

PWD="C:\Utils\FStar\fstar-0.6-alpha"
export FSTAR_HOME=`cygpath -d "$PWD"`
export PATH=`cygpath -d "$PWD/bin"`:$PATH
