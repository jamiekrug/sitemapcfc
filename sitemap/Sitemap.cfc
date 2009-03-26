<!---
--------------------------------------------------------------------------------
LICENSE INFORMATION:

	Copyright 2009 James (Jamie) E. Krug III

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

--------------------------------------------------------------------------------
DOCUMENT INFORMATION:

	Title:		SitemapCFC

	Author:		Jamie Krug
	E-mail:		jamie@thekrugs.com
	Web site:	http://jamiekrug.com/

	Purpose:	Model a sitemaps.org protocol sitemap XML document.

	Usage:		Use a CFC explorer to view method signatures and descriptions.
				(Or, see hint attributes in this document.)
				Also, http://jamiekrug.com/blog/index.cfm/sitemapcfc

--------------------------------------------------------------------------------
--->
<cfcomponent output="false" hint="I model a sitemap.xml file based on the sitemaps.org protocol and can also generate XML page output or write a sitemap XML file to disk.">

	<cfscript>
		variables.URL_CHILD_KEYS = 'loc,lastmod,changefreq,priority';
		variables.CHANGEFREQ_VALUES = 'always,hourly,daily,weekly,monthly,yearly,never';
	</cfscript>

	<cffunction name="init" access="public" output="false" hint="Constructor; initializes sitemap object with a collection of URLs.">
		<cfargument name="collection" type="any" required="true" hint="The url collection to be represented in a sitemap; acceptable types are a list, a query, an array or an array of structs. Query or array of structs collection types must have a 'loc' key/column or a mapping in the collectionKeyMap argument (e.g., collectionKeyMap.loc='pageURL' when collection argument is a query with a 'pageURL' column representative of the 'loc' sitemap XML element). Other child tags of the &lt;url&gt; element, as described at http://sitemaps.org/protocol.php, are also valid key/column names (and can also be mapped to respective key/column names, again using the collectionKeyMap argument). 'lastmod' values may be any valid date/time string or object, as they will automatically be converted to proper W3C datetime format when initialized into collection property." />
		<cfargument name="collectionKeyMap" type="struct" required="false" default="#structNew()#" hint="The mapping of standard sitemaps.org protocol 'url' child element names (#variables.URL_CHILD_KEYS#) to respective keys/columns in collection argument (e.g., collectionKeyMap.loc='pageURL' when collection argument is a query with a 'pageURL' column representative of the 'loc' sitemap XML tag)." />

		<cfscript>
			setCollectionKeyMap(arguments.collectionKeyMap);
			setCollection(arguments.collection);

			return this;
		</cfscript>
	</cffunction>


	<!--- PUBLIC METHODS --->


	<cffunction name="getCollection" returntype="array" access="public" output="false" hint="Returns an array of structs (modeling a sitemaps.org protocol &lt;urlset&gt; (each array item represents a &lt;url&gt; tag, with struct keys matching &lt;url&gt; child tag names).">
		<cfreturn variables.instance.collection />
	</cffunction>


	<cffunction name="getXml" returntype="xml" access="public" output="false" hint="Returns an XML object modeling sitemap object's representation of the sitemaps.org protocol sitemap XML document.">
		<cfreturn xmlParse( getXmlString() ) />
	</cffunction>


	<cffunction name="getXmlString" returntype="string" access="public" output="false" hint="Returns a raw XML string modeling sitemap object's representation of the sitemaps.org protocol sitemap XML document.">
		<cfscript>
			var result = '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9" url="http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
			var collection = getCollection();
			var i = '';

			for (i=1; i LTE arrayLen(collection); i=i+1) {
				result = result & buildSitemapUrl( argumentCollection=collection[i] );
			}

			result = result & '</urlset>';

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="toFile" returntype="any" access="public" output="false" hint="Writes sitemap XML document to disk.">
		<cfargument name="filePath" type="string" required="true" hint="Absolute path to sitemap XML file to be written to disk." />

		<cffile action="write" file="#arguments.filePath#" output="#getXmlString()#" addnewline="false" charset="utf-8" mode="664" />

		<cfreturn this />
	</cffunction>


	<cffunction name="toPageOutput" returntype="any" access="public" output="true" hint="Sends sitemap XML document as binary page output to browser.">
		<cfcontent variable="#toBinary( toBase64( getXmlString() ) )#" type="text/xml; charset=utf-8" />
		<cfreturn this />
	</cffunction>


	<!--- PRIVATE METHODS --->


	<cffunction name="buildSitemapUrl" returntype="string" access="private" output="false" hint="Returns raw XML string for a &lt;url&gt; element, including &lt;loc&gt; child tag and any other optional child tag arguments passed.">
		<cfargument name="loc" type="string" required="true" hint="URL of the page." />
		<cfargument name="lastmod" type="string" required="false" hint="The date of last modification of the file, in W3C Datetime format (http://www.w3.org/TR/NOTE-datetime)." />
		<cfargument name="changefreq" type="string" required="false" hint="Valid values are #variables.CHANGEFREQ_VALUES# (see &lt;changefreq&gt; XML tag definition at http://sitemaps.org/protocol.php for details)." />
		<cfargument name="priority" type="numeric" required="false" hint="Valid values range from 0.0 to 1.0 (see &lt;priority&gt; XML tag definition at http://sitemaps.org/protocol.php for details)." />

		<cfscript>
			var result = '<url>';

			result = result & '<loc>' & xmlFormat(arguments.loc) & '</loc>';

			if ( structKeyExists(arguments, 'lastmod') ) {
				result = result & '<lastmod>' & arguments.lastmod & '</lastmod>';
			}
			if ( structKeyExists(arguments, 'changefreq') ) {
				result = result & '<changefreq>' & arguments.changefreq & '</changefreq>';
			}
			if ( structKeyExists(arguments, 'priority') ) {
				result = result & '<priority>' & arguments.priority & '</priority>';
			}

			result = result & '</url>';

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="cleanUrl" returntype="struct" access="private" output="false" hint="Validate and properly format each url item child.">
		<cfargument name="source" type="struct" required="true" />

		<cfscript>
			var result = structNew();
			var theUrl = arguments.source;
			var key = '';

			// trim all simple values:
			for (key IN theUrl) {
				if ( isSimpleValue( theUrl[key] ) ) {
					theUrl[key] = trim( theUrl[key] );
				}
			}

			if ( NOT structKeyExists(theUrl, 'loc') ) {
				throwError('loc key is required for each collection item.');
			}
			if ( NOT isValid('URL', theUrl.loc) ) {
				throwError('loc must be a valid URL.');
			}

			result.loc = theUrl.loc;

			if ( structKeyExists(theUrl, 'lastmod')
					AND ( NOT isSimpleValue(theUrl.lastmod) OR ( isSimpleValue(theUrl.lastmod) AND theUrl.lastmod NEQ '' ) )
			) {
				if ( isValid('date', theUrl.lastmod) ) {
					result.lastmod = formatAsW3CDateTime(theUrl.lastmod);
				} else if ( isW3cDateTimeFormat(theUrl.lastmod) ) {
					result.lastmod = theUrl.lastmod;
				} else {
					throwError('lastmod must be a valid CFML date/time string or object, or a properly formatted W3C datetime string.');
				}
			}

			if ( structKeyExists(theUrl, 'changefreq') AND isSimpleValue(theUrl.changefreq) AND theUrl.changefreq NEQ '' ) {
				if ( NOT listFindNoCase(variables.CHANGEFREQ_VALUES, theUrl.changefreq) ) {
					throwError('changefreq must be one of: #variables.CHANGEFREQ_VALUES#.');
				}
				result.changefreq = lCase(theUrl.changefreq);
			}

			if ( structKeyExists(theUrl, 'priority') AND isSimpleValue(theUrl.priority) AND theUrl.priority NEQ '' ) {
				if ( NOT isValid('range', theUrl.priority, 0, 1) ) {
					throwError('priority valid values range from 0.0 to 1.0.');
				}
				result.priority = numberFormat(theUrl.priority, '9.9');
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="formatAsW3CDateTime" returntype="string" access="private" output="false" hint="Formats a date/time argument to UTC in a format complete with date, hours, minuts and seconds conforming to the W3C standard (http://www.w3.org/TR/NOTE-datetime).">
		<cfargument name="dateTime" type="date" required="true" />

		<cfscript>
			var utc = dateConvert('local2Utc', arguments.dateTime);
			var result = dateFormat(utc, 'yyyy-mm-dd') & 'T' & timeFormat(utc, 'HH:mm:ss') & 'Z';

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getCollectionFromArray" returntype="array" access="private" output="false">
		<cfargument name="collection" type="array" required="true" hint="The url collection to be represented in a sitemap, as a one-dimensional array of string URLs." />

		<cfscript>
			var result = arrayNew(1);
			var thisUrl = structNew();
			var i = '';

			for (i=1; i LTE arrayLen(arguments.collection); i=i+1) {
				thisUrl['loc'] = arguments.collection[i];

				// clean (and validate) this url item:
				thisUrl = cleanUrl(thisUrl);

				// append current item to collection:
				arrayAppend(result, duplicate(thisUrl) );
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getCollectionFromArrayOfStructs" returntype="array" access="private" output="false">
		<cfargument name="collection" type="array" required="true" hint="The url collection to be represented in a sitemap, as an array of structs." />

		<cfscript>
			var result = arrayNew(1);
			var keyMap = getCollectionKeyMap();
			var key = '';
			var thisUrl = structNew();
			var urlSource = '';
			var sourceKey = '';
			var i = '';
			var j = '';

			// loop over collection to set relevant data into instance collection
			for (i=1; i LTE arrayLen(arguments.collection); i=i+1) {
				urlSource = arguments.collection[i];

				// loop over valid sitemap url keys and set those available for collection item:
				for (key IN keyMap) {
					sourceKey = keyMap[key];
					if ( structKeyExists(urlSource, sourceKey) ) {
						thisUrl[key] = urlSource[sourceKey];
					}
				}

				// clean (and validate) this url item:
				thisUrl = cleanUrl(thisUrl);

				// append current item to collection:
				arrayAppend(result, duplicate(thisUrl) );
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getCollectionFromList" returntype="array" access="private" output="false">
		<cfargument name="collection" type="string" required="true" hint="The url collection to be represented in a sitemap, as a comma-delimited array of string URLs." />

		<cfreturn getCollectionFromArray( listToArray(arguments.collection) ) />
	</cffunction>


	<cffunction name="getCollectionFromQuery" returntype="array" access="private" output="false">
		<cfargument name="collection" type="query" required="true" hint="The url collection to be represented in a sitemap." />

		<cfscript>
			var result = arrayNew(1);
			var keyMap = getCollectionKeyMap();
			var key = '';
			var thisUrl = structNew();
			var column = '';
			var i = '';
			var j = '';

			// for better looping efficiency, remove keys from keyMap that are not present in query column list:
			for (key IN keyMap) {
				if ( NOT listFindNoCase(arguments.collection.columnList, keyMap[key]) ) {
					structDelete(keyMap, key);
				}
			}

			// loop over collection to set relevant data into instance collection
			for (i=1; i LTE arguments.collection.recordCount; i=i+1) {
				// loop over valid sitemap url keys and set collection item:
				for (key IN keyMap) {
					column = keyMap[key];
					thisUrl[key] = arguments.collection[column][i];
				}

				// clean (and validate) this url item:
				thisUrl = cleanUrl(thisUrl);

				// append current item to collection:
				arrayAppend(result, duplicate(thisUrl) );
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getDefaultCollectionKeyMap" returntype="struct" access="private" output="false">
		<cfscript>
			var keyMap = structNew();
			var key = '';
			var i = '';

			for (i=1; i LTE listLen(variables.URL_CHILD_KEYS); i=i+1) {
				key = listGetAt(variables.URL_CHILD_KEYS, i);
				keyMap[key] = key;
			}

			return keyMap;
		</cfscript>
	</cffunction>


	<cffunction name="getW3cDateTimeFormat" returntype="string" access="private" output="false" hint="Returns W3C datetime format (dateYear,dateYearMonth,dateComplete,dateTimeToMinutes,dateTimeToSeconds,dateTimeComplete); returns empty string if no valid format match (http://www.w3.org/TR/NOTE-datetime).">
		<cfargument name="dateTimeString" type="string" required="true" />

		<cfscript>
			var dt = arguments.dateTimeString;
			var format = '';
			var reYear = '[1-9][0-9]{3}';
			var reMonth = '(0[1-9])|(1[0-2])';
			var reDay = '(0[1-9])|([1-2][0-9])|(3[0-1])';
			var reHours = '([0-1][0-9])|(2[0-3])';
			var reMinutes = '[0-5][0-9]';
			var reSeconds = reMinutes;
			var reDecimalFractionOfSecond = '[0-9]+';
			var reTimeZoneDesignator = 'Z|([+-](#reHours#):(#reMinutes#))';

			if ( reFind('^#reYear#$', dt) ) {
				format = 'dateYear';
			} else if ( reFind('^(#reYear#)-(#reMonth#)$', dt) ) {
				format = 'dateYearMonth';
			} else if ( reFind('^(#reYear#)-(#reMonth#)-(#reDay#)$', dt) AND isDate(dt) ) {
				format = 'dateComplete';
			} else if ( reFind('^(#reYear#)-(#reMonth#)-(#reDay#)T(#reHours#):(#reMinutes#)(#reTimeZoneDesignator#)$', dt) AND isDate( left(dt, 10) ) ) {
				format = 'dateTimeToMinutes';
			} else if ( reFind('^(#reYear#)-(#reMonth#)-(#reDay#)T(#reHours#):(#reMinutes#):(#reSeconds#)(#reTimeZoneDesignator#)$', dt) AND isDate( left(dt, 10) ) ) {
				format = 'dateTimeToSeconds';
			} else if ( reFind('^(#reYear#)-(#reMonth#)-(#reDay#)T(#reHours#):(#reMinutes#):(#reSeconds#)\.(#reDecimalFractionOfSecond#)(#reTimeZoneDesignator#)$', dt) AND isDate( left(dt, 10) ) ) {
				format = 'dateTimeComplete';
			}

			return format;
		</cfscript>
	</cffunction>


	<cffunction name="isW3cDateTimeFormat" returntype="boolean" access="private" output="false" hint="Validates W3C datetime formats, which are a subset of valid ISO 8601 dates/times (as described at http://www.w3.org/TR/NOTE-datetime).">
		<cfargument name="dateTimeString" type="string" required="true" />

		<cfreturn len( getW3cDateTimeFormat(arguments.dateTimeString) ) />
	</cffunction>


	<cffunction name="setCollection" returntype="void" access="private" output="false" hint="Property: collection">
		<cfargument name="collection" type="any" required="true" hint="The url collection to be represented in a sitemap; acceptable types are a list of locations/URLs, a query or an array of structs." />

		<cfscript>
			if ( isSimpleValue(arguments.collection) ) {
				variables.instance.collection = getCollectionFromList(arguments.collection);
			} else if ( isArray(arguments.collection) ) {
				if ( arrayLen(arguments.collection) AND isStruct( arguments.collection[1] ) ) {
					variables.instance.collection = getCollectionFromArrayOfStructs(arguments.collection);
				} else {
					variables.instance.collection = getCollectionFromArray(arguments.collection);
				}
			} else {
				variables.instance.collection = getCollectionFromQuery(arguments.collection);
			}
		</cfscript>
	</cffunction>


	<cffunction name="setCollectionKeyMap" returntype="void" access="private" output="false" hint="Property: collectionKeyMap">
		<cfargument name="collectionKeyMap" type="struct" required="true" />

		<cfscript>
			var result = getDefaultCollectionKeyMap();
			var key = '';

			for (key IN arguments.collectionKeyMap) {
				if ( NOT listFindNoCase(variables.URL_CHILD_KEYS, key) ) {
					throwError('Invalid collectionKeyMap; valid keys are #variables.URL_CHILD_KEYS#.');
				}
				// replace default key mapping:
				result[key] = arguments.collectionKeyMap[key];
			}

			variables.instance.collectionKeyMap = result;
		</cfscript>
	</cffunction>
	<cffunction name="getCollectionKeyMap" returntype="struct" access="public" output="false" hint="Property: collectionKeyMap">
		<cfreturn variables.instance.collectionKeyMap />
	</cffunction>


	<cffunction name="throwError" returntype="void" access="private" output="false">
		<cfargument name="message" type="string" required="true" />

		<cfthrow type="#getMetaData(this).name#" message="#arguments.message#" />
	</cffunction>


</cfcomponent>