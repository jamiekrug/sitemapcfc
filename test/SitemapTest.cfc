<cfcomponent extends="Base">


	<cfscript>
		variables.URL_TEMPLATE = 'http://site.com/page${count}.html';

		variables.DEFAULT_COLLECTION_SIZE = 10;
		variables.DEFAULT_LASTMOD = '2006-05-01T16:20:00Z';
		variables.DEFAULT_CHANGEFREQ = 'never';
		variables.DEFAULT_PRIORITY = '0.5';

		variables.URL_CHILD_KEYS = 'loc,lastmod,changefreq,priority';
		variables.CHANGEFREQ_VALUES = 'always,hourly,daily,weekly,monthly,yearly,never';
	</cfscript>


	<!--- TEST INIT: --->


	<cffunction name="test_init_array" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArray();
			var expectedCollection = getSampleExpectedCollection();
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_list" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitList();
			var expectedCollection = getSampleExpectedCollection();
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_arrayOfStructs_basic" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArrayOfStructs();
			var expectedCollection = duplicate( initCollection );
			var actualCollection = createSitemap().init( initCollection ).getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_arrayOfStructs_all_keys_standard" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArrayOfStructs();
			var expectedCollection = '';
			var actualCollection = '';
			var i = '';

			for ( i=1; i LTE arrayLen(initCollection); i=i+1 ) {
				initCollection[i].lastmod = variables.DEFAULT_LASTMOD;
				initCollection[i].changefreq = variables.DEFAULT_CHANGEFREQ;
				initCollection[i].priority = variables.DEFAULT_PRIORITY;
			}

			expectedCollection = duplicate( initCollection );

			actualCollection = createSitemap().init( initCollection ).getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_query_basic" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitQueryBasic();
			var expectedCollection = getSampleExpectedCollection();
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_query_all_keys_standard" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitQueryAllStandardKeys();
			var expectedCollection = getSampleExpectedCollection();
			var actualCollection = '';

			for ( i=1; i LTE arrayLen(expectedCollection); i=i+1 ) {
				expectedCollection[i].lastmod = variables.DEFAULT_LASTMOD;
				expectedCollection[i].changefreq = variables.DEFAULT_CHANGEFREQ;
				expectedCollection[i].priority = variables.DEFAULT_PRIORITY;
			}

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_locPrefix_locSuffix" access="public">
		<cfscript>
			var sitemap = createSitemap();
			var expected = arrayNew(1);
			var actual = '';

			expected[1] = structNew();
			expected[1].loc = 'http://host/page1.html';
			actual = sitemap.init( collection = 'page1', locPrefix = 'http://host/', locSuffix = '.html' ).getCollection();

			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<!--- TEST PUBLIC METHODS: --->


	<cffunction name="test_getXml" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var actual = '';
			var expected = '';

			expected = xmlParse( getSampleXmlDoc() );
			actual = sitemap.init( getSampleInitQueryBasic() ).getXml();
			assertEquals(expected, actual);

			expected = xmlParse( getSampleXmlDoc( isIncludeAllStandardKeys = true ) );
			actual = sitemap.init( getSampleInitQueryAllStandardKeys() ).getXml();
			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<cffunction name="test_getXmlString" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var actual = '';
			var expected = '';

			expected = getSampleXmlDoc();
			actual = sitemap.init( getSampleInitQueryBasic() ).getXmlString();
			assertEquals(expected, actual);

			expected = getSampleXmlDoc( isIncludeAllStandardKeys = true );
			actual = sitemap.init( getSampleInitQueryAllStandardKeys() ).getXmlString();
			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<cffunction name="test_toFile" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var actual = '';
			var expected = '';
			var file = getTempDirectory() & 'SitemapTest_test_toFile' & replace(createUUID(), '-', '', 'all') & '.tmp';

			expected = getSampleXmlDoc();

			sitemap.init( getSampleInitQueryBasic() ).toFile( file );
		</cfscript>

		<cffile action="read" file="#file#" variable="actual" charset="utf-8" />
		<cffile action="delete" file="#file#" />

		<cfscript>
			assertEquals(expected, actual);

			expected = getSampleXmlDoc( isIncludeAllStandardKeys = true );

			sitemap.init( getSampleInitQueryAllStandardKeys() ).toFile( file );
		</cfscript>

		<cffile action="read" file="#file#" variable="actual" charset="utf-8" />
		<cffile action="delete" file="#file#" />

		<cfscript>
			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<!--- TEST PRIVATE METHODS: --->


	<cffunction name="test_buildSitemapUrl" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var args = structNew();
			var expectedChildTags = '';
			var expected = '';
			var actual = '';

			makePublic(sitemap, 'buildSitemapUrl');

			args['loc'] = getSampleLoc('1');
			expectedChildTags = '<loc>#args['loc']#</loc>';
			expected = '<url>#expectedChildTags#</url>';
			actual = sitemap.buildSitemapUrl( argumentCollection=args );
			assertEquals(expected, actual);

			args['lastmod'] = variables.DEFAULT_LASTMOD;
			expectedChildTags = expectedChildTags & '<lastmod>#args['lastmod']#</lastmod>';
			expected = '<url>#expectedChildTags#</url>';
			actual = sitemap.buildSitemapUrl( argumentCollection=args );
			assertEquals(expected, actual);

			args['changefreq'] = variables.DEFAULT_CHANGEFREQ;
			expectedChildTags = expectedChildTags & '<changefreq>#args['changefreq']#</changefreq>';
			expected = '<url>#expectedChildTags#</url>';
			actual = sitemap.buildSitemapUrl( argumentCollection=args );
			assertEquals(expected, actual);

			args['priority'] = variables.DEFAULT_PRIORITY;
			expectedChildTags = expectedChildTags & '<priority>#args['priority']#</priority>';
			expected = '<url>#expectedChildTags#</url>';
			actual = sitemap.buildSitemapUrl( argumentCollection=args );
			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<cffunction name="test_cleanUrl" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var arg = '';
			var expected = '';

			makePublic( sitemap, 'cleanUrl' );

			arg = structNew();
			expected = structNew();
			arg['loc'] = '	http://host/page1 ';
			expected['loc'] = 'http://host/page1';
			arg['lastmod'] = '7/11/2009 1:00 PM';
			expected['lastmod'] = '2009-07-11T13:00#alternateTimeZoneDesignator()#';
			arg['changefreq'] = '  monthly
									';
			expected['changefreq'] = 'monthly';
			arg['priority'] = ' 0.1234	';
			expected['priority'] = '0.1';

			actual = sitemap.cleanUrl( arg );

			assertEquals( expected, actual );
		</cfscript>
	</cffunction>


	<cffunction name="test_formatAsW3CDateTime" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var actual = '';
			var expected = '';

			makePublic(sitemap, 'formatAsW3CDateTime');

			actual = sitemap.formatAsW3CDateTime( '7/14/09' );
			expected = '2009-07-14';
			assertEquals( expected, actual );

			actual = sitemap.formatAsW3CDateTime( '7/2009' );
			expected = '2009-07-01';
			assertEquals( expected, actual );

			actual = sitemap.formatAsW3CDateTime( '7/14/09 5:00 PM' );
			expected = '2009-07-14T17:00#alternateTimeZoneDesignator()#';
			assertEquals( expected, actual );

			actual = sitemap.formatAsW3CDateTime( "{ts '2009-07-14 16:09:11'}" );
			expected = '2009-07-14T16:09:11#alternateTimeZoneDesignator()#';
			assertEquals( expected, actual );

			actual = sitemap.formatAsW3CDateTime( '2009-07-14 16:09:11.5' );
			expected = '2009-07-14T16:09:11#alternateTimeZoneDesignator()#';
			assertEquals( expected, actual );
		</cfscript>
	</cffunction>


	<cffunction name="test_getCollectionFromArray" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var arrayCollection = arrayNew(1);
			var expected = arrayNew(1);
			var actual = '';
			var tempStruct = structNew();

			makePublic(sitemap, 'getCollectionFromArray');

			arrayCollection[1] = 'http://host/page1';
			arrayCollection[2] = 'http://host/page2';

			actual = sitemap.getCollectionFromArray(arrayCollection);

			tempStruct['loc'] = 'http://host/page1';
			expected[1] = duplicate(tempStruct);
			tempStruct['loc'] = 'http://host/page2';
			expected[2] = duplicate(tempStruct);

			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<cffunction name="test_getCollectionFromArrayOfStructs" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var arrayOfStructsCollection = arrayNew(1);
			var expected = arrayNew(1);
			var actual = '';
			var tempStruct = '';

			makePublic(sitemap, 'getCollectionFromArrayOfStructs');

			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page1';
			tempStruct['changefreq'] = 'daily';
			arrayOfStructsCollection[1] = duplicate(tempStruct);
			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page2';
			arrayOfStructsCollection[2] = duplicate(tempStruct);

			actual = sitemap.getCollectionFromArrayOfStructs(arrayOfStructsCollection);

			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page1';
			tempStruct['changefreq'] = 'daily';
			expected[1] = duplicate(tempStruct);
			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page2';
			expected[2] = duplicate(tempStruct);

			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<cffunction name="test_getCollectionFromQuery" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var queryCollection = queryNew('loc,changefreq');
			var expected = arrayNew(1);
			var actual = '';
			var tempStruct = '';

			makePublic(sitemap, 'getCollectionFromQuery');

			queryAddRow(queryCollection);
			querySetCell(queryCollection, 'loc', 'http://host/page1');
			querySetCell(queryCollection, 'changefreq', 'daily');
			queryAddRow(queryCollection);
			querySetCell(queryCollection, 'loc', 'http://host/page2');
			querySetCell(queryCollection, 'changefreq', '');

			actual = sitemap.getCollectionFromQuery(queryCollection);

			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page1';
			tempStruct['changefreq'] = 'daily';
			expected[1] = duplicate(tempStruct);
			tempStruct = structNew();
			tempStruct['loc'] = 'http://host/page2';
			expected[2] = duplicate(tempStruct);

			assertEquals(expected, actual);
		</cfscript>
	</cffunction>


	<!--- TEST W3C DATETIME RELATED METHODS: --->


	<cffunction name="test_getW3cDateTimeFormat" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			makePublic(sitemap, 'getW3cDateTimeFormat');

			assertEquals( 'dateYear', 			sitemap.getW3cDateTimeFormat('1977') );
			assertEquals( 'dateYearMonth', 		sitemap.getW3cDateTimeFormat('1977-01') );
			assertEquals( 'dateComplete', 		sitemap.getW3cDateTimeFormat('1977-01-09') );
			assertEquals( 'dateTimeToMinutes',	sitemap.getW3cDateTimeFormat('1977-01-09T00:00Z') );
			assertEquals( 'dateTimeToMinutes',	sitemap.getW3cDateTimeFormat('1977-01-09T12:00+05:00') );
			assertEquals( 'dateTimeToMinutes',	sitemap.getW3cDateTimeFormat('1977-01-09T23:59-05:00') );
			assertEquals( 'dateTimeToSeconds',	sitemap.getW3cDateTimeFormat('1977-01-09T00:00:00Z') );
			assertEquals( 'dateTimeToSeconds',	sitemap.getW3cDateTimeFormat('1977-01-09T12:00:30+05:00') );
			assertEquals( 'dateTimeToSeconds',	sitemap.getW3cDateTimeFormat('1977-01-09T23:59:59-05:00') );
			assertEquals( 'dateTimeComplete',	sitemap.getW3cDateTimeFormat('1977-01-09T00:00:00.0Z') );
			assertEquals( 'dateTimeComplete',	sitemap.getW3cDateTimeFormat('1977-01-09T12:00:30.12+00:00') );
			assertEquals( 'dateTimeComplete',	sitemap.getW3cDateTimeFormat('1977-01-09T23:59:59.123-00:00') );
			assertEquals( '', 					sitemap.getW3cDateTimeFormat('1/9/1977') );
		</cfscript>
	</cffunction>


	<cffunction name="test_isW3cDateTimeFormat_false" returntype="void" access="public" output="false">
		<cfscript>
			var testVals = arrayNew(1);
			var sitemap = createSitemap();

			makePublic(sitemap, 'isW3cDateTimeFormat');

			arrayAppend(testVals, '977');
			arrayAppend(testVals, '1977-00');
			arrayAppend(testVals, '1977-01-32');
			arrayAppend(testVals, '1977-13-09');
			arrayAppend(testVals, '2009-02-29');
			arrayAppend(testVals, '1977-01-09T24:00Z');
			arrayAppend(testVals, '1977-01-09T00:60Z');
			arrayAppend(testVals, '1977-01-09T00:00');
			arrayAppend(testVals, '1977-01-0900:00Z');
			arrayAppend(testVals, '1977-01-09 00:00Z');
			arrayAppend(testVals, '1977-01-09 00:00');
			arrayAppend(testVals, '1977-01-09T12:00+24:00');
			arrayAppend(testVals, '1977-01-09T23:59-05:60');
			arrayAppend(testVals, '1977-01-09T00:00:60Z');
			arrayAppend(testVals, '1977-01-09T00:00:00.Z');
			arrayAppend(testVals, '1977-01-09T00:00:00.xZ');
			arrayAppend(testVals, '1977-01-09T00:00:00.0.0Z');

			for (i=1; i LTE arrayLen(testVals); i=i+1) {
				assertFalse( sitemap.isW3cDateTimeFormat( testVals[i] ), "isW3cDateTimeFormat('#testVals[i]#') passed when expected to fail!" );
			}
		</cfscript>
	</cffunction>


	<cffunction name="test_isW3cDateTimeFormat_true" returntype="void" access="public" output="false">
		<cfscript>
			var testVals = arrayNew(1);
			var sitemap = createSitemap();

			makePublic(sitemap, 'isW3cDateTimeFormat');

			arrayAppend(testVals, '1977');
			arrayAppend(testVals, '1977-01');
			arrayAppend(testVals, '1977-01-09');
			arrayAppend(testVals, '2008-02-29');
			arrayAppend(testVals, '1977-01-09T00:00Z');
			arrayAppend(testVals, '1977-01-09T12:00+05:00');
			arrayAppend(testVals, '1977-01-09T23:59-05:00');
			arrayAppend(testVals, '1977-01-09T00:00:00Z');
			arrayAppend(testVals, '1977-01-09T12:00:30+05:00');
			arrayAppend(testVals, '1977-01-09T23:59:59-05:00');
			arrayAppend(testVals, '1977-01-09T00:00:00.0Z');
			arrayAppend(testVals, '1977-01-09T12:00:30.12+00:00');
			arrayAppend(testVals, '1977-01-09T23:59:59.123-00:00');

			for (i=1; i LTE arrayLen(testVals); i=i+1) {
				assertTrue( sitemap.isW3cDateTimeFormat( testVals[i] ), "isW3cDateTimeFormat('#testVals[i]#') failed when expected to pass!" );
			}
		</cfscript>
	</cffunction>


	<!--- TEST COLLECTION KEY MAP/ALIAS METHODS: --->


	<cffunction name="test_getDefaultCollectionKeyMap" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var keyMapExpected = getDefaultCollectionKeyMap();
			var keyMapActual = '';

			makePublic(sitemap, 'getDefaultCollectionKeyMap');

			keyMapActual = sitemap.getDefaultCollectionKeyMap();

			assertEquals( keyMapExpected , keyMapActual );
		</cfscript>
	</cffunction>


	<cffunction name="test_getSetCollectionKeyMap" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var keyMapArg = structNew();
			var keyMapExpected = getDefaultCollectionKeyMap();
			var keyMapActual = '';

			makePublic(sitemap, 'setCollectionKeyMap');
			makePublic(sitemap, 'getCollectionKeyMap');

			sitemap.setCollectionKeyMap(keyMapArg);
			keyMapActual = sitemap.getCollectionKeyMap();

			assertEquals( keyMapExpected , keyMapActual );

			keyMapArg['loc'] = 'custom_loc';
			keyMapArg['changefreq'] = 'custom_changefreq';

			keyMapExpected['loc'] = keyMapArg['loc'];
			keyMapExpected['changefreq'] = keyMapArg['changefreq'];

			sitemap.setCollectionKeyMap(keyMapArg);
			keyMapActual = sitemap.getCollectionKeyMap();

			assertEquals( keyMapExpected , keyMapActual );
		</cfscript>
	</cffunction>


	<!--- MISC. TESTS: --->


	<cffunction name="test_defaults" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();
			var actual = '';
			var collection = arrayNew(1);
			var defaults = structNew();
			var expected = arrayNew(1);

			collection[1] = structNew();
			collection[1].loc = 'http://host/page1';
			collection[1].changefreq = 'weekly';
			collection[1].lastmod = '7/16/2009';
			collection[1].priority = '1.0';
			collection[2] = structNew();
			collection[2].loc = 'http://host/page2';

			defaults.changefreq = 'monthly';
			defaults.lastmod = '2009-07-16';
			defaults.priority = '0.5';

			expected[1] = structNew();
			expected[1].loc = collection[1].loc;
			expected[1].changefreq = collection[1].changefreq;
			expected[1].lastmod = '2009-07-16';
			expected[1].priority = collection[1].priority;
			expected[2] = structNew();
			expected[2].loc = collection[2].loc;
			expected[2].changefreq = defaults.changefreq;
			expected[2].lastmod = defaults.lastmod;
			expected[2].priority = defaults.priority;

			actual = sitemap.init( collection=collection, defaults=defaults ).getCollection();

			assertEquals( expected , actual );
		</cfscript>
	</cffunction>


	<!--- PRIVATE METHODS: --->


	<cffunction name="alternateTimeZoneDesignator" returntype="string" access="private" output="false">
		<cfscript>
			var localDateTime = now();
			var utcDateTime = dateConvert( 'local2Utc', localDateTime );
			var diffTotalMinutes = dateDiff( 'n', utcDateTime, localDateTime );
			var absTotalMinutes = abs( diffTotalMinutes );
			var offsetHour = int( absTotalMinutes/60 );
			var offsetMinute = absTotalMinutes MOD 60;
			var offsetPrefix = '+';

			if ( diffTotalMinutes EQ 0 ) return 'Z';

			if ( diffTotalMinutes LT 0 ) offsetPrefix = '-';

			return offsetPrefix & right( '0#offsetHour#', 2 ) & ':' & right( '0#offsetMinute#', 2 );
		</cfscript>
	</cffunction>


	<cffunction name="createSitemap" returntype="sitemap.Sitemap" access="private" output="false">
		<cfreturn createObject('component', 'sitemap.Sitemap').init('') />
	</cffunction>


	<cffunction name="getDefaultCollectionKeyMap" returntype="struct" access="private" output="false">
		<cfscript>
			var defaultKeyMap = structNew();

			defaultKeyMap['loc'] = 'loc';
			defaultKeyMap['lastmod'] = 'lastmod';
			defaultKeyMap['changefreq'] = 'changefreq';
			defaultKeyMap['priority'] = 'priority';

			return defaultKeyMap;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleExpectedCollection" returntype="array" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs in collection (whole number, 1 or greater)." />

		<cfscript>
			var result = arrayNew(1);
			var i = '';

			for (i=1; i LTE arguments.count; i=i+1) {
				result[i] = structNew();
				result[i].loc = getSampleLoc(i);
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleInitArray" returntype="array" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfscript>
			var result = arrayNew(1);
			var i = '';

			for (i=1; i LTE arguments.count; i=i+1) {
				result[i] = getSampleLoc(i);
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleInitArrayOfStructs" returntype="array" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfreturn getSampleExpectedCollection( arguments.count ) />
	</cffunction>


	<cffunction name="getSampleInitList" returntype="string" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfreturn arrayToList( getSampleInitArray( arguments.count ) ) />
	</cffunction>


	<cffunction name="getSampleInitQueryAllStandardKeys" returntype="query" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs in collection (whole number, 1 or greater)." />

		<cfscript>
			var result = queryNew('loc,lastmod,changefreq,priority');
			var urls = getSampleInitArray( arguments.count );
			var i = '';

			for (i=1; i LTE arrayLen(urls); i=i+1) {
				queryAddRow( result );
				querySetCell( result, 'loc',		urls[i] );
				querySetCell( result, 'lastmod',	variables.DEFAULT_LASTMOD );
				querySetCell( result, 'changefreq',	variables.DEFAULT_CHANGEFREQ );
				querySetCell( result, 'priority',	variables.DEFAULT_PRIORITY );
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleInitQueryBasic" returntype="query" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs in collection (whole number, 1 or greater)." />

		<cfscript>
			var result = queryNew('loc');
			var urls = getSampleInitArray( arguments.count );
			var i = '';

			for (i=1; i LTE arrayLen(urls); i=i+1) {
				queryAddRow( result );
				querySetCell( result, 'loc', urls[i] );
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleLoc" returntype="string" access="private" output="false">
		<cfargument name="token" type="string" required="true" />

		<cfreturn replace(variables.URL_TEMPLATE, '${count}', arguments.token) />
	</cffunction>


	<cffunction name="getSampleXmlDoc" returntype="string" access="private" output="false">
		<cfargument name="count" type="numeric" required="false" default="#variables.DEFAULT_COLLECTION_SIZE#" hint="Number of URLs in collection (whole number, 1 or greater)." />
		<cfargument name="isIncludeAllStandardKeys" type="boolean" required="false" default="false" />

		<cfscript>
			var result = getXmlDocOpen();
			var i = '';

			for (i=1; i LTE arguments.count; i=i+1) {
				result = result & '<url><loc>' & getSampleLoc(i) & '</loc>';

				if ( arguments.isIncludeAllStandardKeys ) {
					result = result & '<lastmod>' & variables.DEFAULT_LASTMOD & '</lastmod>';
					result = result & '<changefreq>' & variables.DEFAULT_CHANGEFREQ & '</changefreq>';
					result = result & '<priority>' & variables.DEFAULT_PRIORITY & '</priority>';
				}

				result = result & '</url>';
			}

			result = result & getXmlDocClose();

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getXmlDocClose" returntype="string" access="private" output="false">
		<cfreturn '</urlset>' />
	</cffunction>


	<cffunction name="getXmlDocOpen" returntype="string" access="private" output="false">
		<cfreturn '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9" url="http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' />
	</cffunction>


</cfcomponent>