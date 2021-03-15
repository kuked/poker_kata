#!/bin/bash
directory="Porker"

mkdir $directory && cd $directory

swift package init --type library
swift package generate-xcodeproj
