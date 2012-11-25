#!/bin/bash 

PWD="c:\utils\fstar"
export FSTAR_HOME=`cygpath -d "$PWD"`
export PATH=`cygpath -d "$PWD/bin"`:$PATH
