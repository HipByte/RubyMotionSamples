#!/bin/bash

mkdir GHMarkdownParser
git clone git://github.com/Watson1978/GHMarkdownParser.git GHMarkdownParser_source

cd GHMarkdownParser_source
git submodule init
git submodule update
cd GHMarkdownParser

xcodebuild
cp build/Release/GHMarkdownParser.a ../../GHMarkdownParser
cp GHMarkdownParser/Foundation\ and\ Class\ Additions/NSString+GHMarkdownParser.h ../../GHMarkdownParser
cp GHMarkdownParser/GHMarkdownParser.h ../../GHMarkdownParser