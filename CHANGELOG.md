# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html). 

## [1.0.2] - 2018-10-15
### Added
- EBSCOhost links are removed from citation styles and exports by default


## [1.0.1] - 2018-10-10
### Added
- Citation styles/exports are added to Records
- Retrieve citation styles/exports for a Record ID or list of Record IDs
- Retrieve a list of available citation styles/exports from Info
- Citation styles/exports available in guest mode
### Fixed
- Double-unescapes data with an ephtml section (sul-dlss/SearchWorks #1504)
- Adds searchlinks to subject items when they don't exist #80 (sul-dlss/SearchWorks #1791)
### Changed
- Updates test cassettes with new citation styles/exports API calls

## [1.0.0] - 2018-03-05
### Changed
- Increments version to reflect production ready status

## [0.3.19.pre] - 2018-03-05
### Added
- Optionally (default=off) include quick view images with Records
### Changed
- Reorganizes VCR tests

## [0.3.18.pre] - 2017-10-10
### Fixed
- Fixes session config bug #84

## [0.3.17.pre] - 2017-09-27
### Changed
- Optionally (default=off) titleize facets via `titleize_facets` in config

## [0.3.16.pre] - 2017-09-20
### Added
- Titleize facets
- Autocorrect feature

## [0.3.15.pre] - 2017-09-18
### Added
- Optionally (default=off) converts all searchLink field codes to DE via `all_subjects_search_links` in config
- Optionally (default=off) decodes/sanitizes html in item data and fulltext html via `decode_sanitize_html` in config

## [0.3.14.pre] - 2017-09-14
### Fixed
- Fixes 250+ pagination issues with SourceType and ContentProvider facets

## [0.3.13.pre] - 2017-09-13
### Fixed
- Includes additional Subject and Geographic Subject metadata

## [0.3.12.pre] - 2017-09-11
### Fixed
- Fixes some 250+ pagination issues
### Changed
- Updates tests

## [0.3.11.pre] - 2017-09-06
### Added
- Adds KW (keywords) and SH (subject heading) to solr search fields

[1.0.2]: https://github.com/ebsco/edsapi-ruby/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/ebsco/edsapi-ruby/compare/1.0.0...1.0.1
