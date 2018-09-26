## KSOFileMagic

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/KSOFileMagic.svg)](http://cocoapods.org/?q=KSOFileMagic)
[![Platform](http://img.shields.io/cocoapods/p/KSOFileMagic.svg)]()
[![License](http://img.shields.io/cocoapods/l/KSOFileMagic.svg)](https://github.com/Kosoku/KSOFileMagic/blob/master/license.txt)

*KSOFileMagic* is a iOS/macOS framework that wraps the Darwin file command, which can determine file type by examining file contents. This can be used to identify a file without a file extension or raw data from the network when a MIME type is not provided. The framework prefers to use the UTType family of functions to determine type, but falls back to examining file contents if a file extension is not provided or when examining `NSData` instances.

### Installation

You can install *KSOFileMagic* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework. 

When installing as a framework, ensure you also link to [Stanley](https://github.com/Kosoku/Stanley) as *KSOFileMagic* relies on it.

### Dependencies

Third party:

- [Stanley](https://github.com/Kosoku/Stanley)

Apple:

- `MobileCoreServices`, `iOS`
- `CoreServices`, `macOS`
