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


	<cffunction name="test_init_array" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArray( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
			var actualCollection = '';

			sitemap = createObject('component', 'sitemap.Sitemap').init( initCollection );

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

			sitemap = createObject('component', 'sitemap.Sitemap').init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_arrayOfStructs_basic" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitArrayOfStructs( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = duplicate( initCollection );
			var actualCollection = createObject('component', 'sitemap.Sitemap').init( initCollection ).getCollection();

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

			actualCollection = createObject('component', 'sitemap.Sitemap').init( initCollection ).getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<cffunction name="test_init_query_basic" access="public">
		<cfscript>
			var sitemap = '';
			var initCollection = getSampleInitQueryBasic( variables.DEFAULT_COLLECTION_SIZE );
			var expectedCollection = getSampleExpectedCollection( variables.DEFAULT_COLLECTION_SIZE );
			var actualCollection = '';

			sitemap = createObject('component', 'sitemap.Sitemap').init( initCollection );

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

			sitemap = createObject('component', 'sitemap.Sitemap').init( initCollection );

			actualCollection = sitemap.getCollection();

			assertEquals(expectedCollection, actualCollection);
		</cfscript>
	</cffunction>


	<!--- PRIVATE METHODS: --->


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