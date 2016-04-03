# SitemapCFC

**AGE WARNING: author hasn't used since 2010.** (Automatically exported from code.google.com/p/sitemapcfc on 4/3/2016.)

SitemapCFC is a CFC to model and generate sitemaps.org protocol sitemap.xml documents from flexible data collection types. You can initialize a SitemapCFC object with a collection of URLs in the form of a list, a query or an array of structs. When using a query or array, the column/key names do not matter, as you can specify a simple key mapping as an optional init argument.

## Features Overview

* Use a list, query or array (of structs) to initialize a sitemap object.
* Query column or struct key names used to initialize a Sitemap.cfc object are not important; an optional init() argument can be used to map to standard sitemaps.org protocol tag names.
* Write your sitemap.xml file to disk or dynamically send a sitemap XML document to the browser as binary page output (cfcontent type text/xml).
* Debugging methods available to access a Sitemap.cfc object's URL collection in the form of an array, an XML object or the raw XML string.
* XML document is schema validation ready.
* All initialization data values are cleaned (entity escaping, date/time format, valid string values, etc.) and validated.
* Date(/time) values for the `<lastmod>` tags can be passed in as any valid date/time string or object; they will be automatically converted to UTC in proper W3C Datetime format (again, per sitemaps.org protocol).

### Requirements

This has been fully tested on ColdFusion 8.01 only, but should work fine with ColdFusion MX 6+, Railo 3.0+ (maybe earlier?) and possibly others. I will try to better confirm compatibility and welcome feedback if you have tested other platforms.

### Resources

* [Blog post with useful code usage examples](http://jamiekrug.com/blog/index.cfm/2009/3/20/sitemaps-org-google-yahoo-msn-others-data-driven-sitemap-xml-generator)
* [Author SitemapCFC blog category](http://jamiekrug.com/blog/index.cfm/sitemapcfc)
* [Sitemaps overview and protocol](http://sitemaps.org/)
* [Using Sitemaps with Google](http://www.google.com/support/webmasters/bin/topic.py?hl=en&topic=8467)
