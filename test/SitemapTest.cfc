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
			var initCollection = getSampleInitArray( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_list" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitList( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_arrayOfStructs_basic" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArrayOfStructs( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = duplicate( initCollection );
			var actualCollection = createSitemap().init( initCollection ).getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_arrayOfStructs_all_keys_standard" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArrayOfStructs( variables.DEFAULT_COLLECTION_SIZE );
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
			var initCollection = getSampleInitQueryBasic( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
			var actualCollection = '';

			sitemap = createSitemap().init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_query_all_keys_standard" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitQueryAllStandardKeys( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
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


	<!--- TEST PUBLIC METHODS: --->


	<cffunction name="test_getXml" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_getXml not yet implemented!');
		</cfscript>
	</cffunction>


	<cffunction name="test_getXmlString" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_getXmlString not yet implemented!');
		</cfscript>
	</cffunction>


	<cffunction name="test_toFile" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_toFile not yet implemented!');
		</cfscript>
	</cffunction>


	<!--- TEST PRIVATE METHODS: --->


	<cffunction name="test_buildSitemapUrl" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_buildSitemapUrl not yet implemented!');
		</cfscript>
	</cffunction>


	<cffunction name="test_cleanUrl" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_cleanUrl not yet implemented!');
		</cfscript>
	</cffunction>


	<cffunction name="test_formatAsW3CDateTime" returntype="void" access="public" output="false">
		<cfscript>
			var sitemap = createSitemap();

			fail('test_formatAsW3CDateTime not yet implemented!');
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


	<!--- PRIVATE METHODS: --->


	<cffunction name="createSitemap" returntype="sitemap.Sitemap" access="private" output="false">
		<cfreturn createObject('component', 'sitemap.Sitemap') />
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
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs in collection (whole number, 1 or greater)." />

		<cfscript>
			var result = arrayNew(1);
			var i = '';

			for (i=1; i LTE arguments.count; i=i+1) {
				result[i] = structNew();
				result[i].loc = replace(variables.URL_TEMPLATE, '${count}', i);
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleInitArray" returntype="array" access="private" output="false">
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfscript>
			var result = arrayNew(1);
			var i = '';

			for (i=1; i LTE arguments.count; i=i+1) {
				result[i] = replace(variables.URL_TEMPLATE, '${count}', i);
			}

			return result;
		</cfscript>
	</cffunction>


	<cffunction name="getSampleInitArrayOfStructs" returntype="array" access="private" output="false">
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfreturn getSampleExpectedCollection( arguments.count ) />
	</cffunction>


	<cffunction name="getSampleInitList" returntype="string" access="private" output="false">
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs to return (whole number, 1 or greater)." />

		<cfreturn arrayToList( getSampleInitArray( arguments.count ) ) />
	</cffunction>


	<cffunction name="getSampleInitQueryAllStandardKeys" returntype="query" access="private" output="false">
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs in collection (whole number, 1 or greater)." />

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
		<cfargument name="count" type="numeric" required="true" hint="Number of URLs in collection (whole number, 1 or greater)." />

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


</cfcomponent>