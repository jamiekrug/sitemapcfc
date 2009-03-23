<cfcomponent extends="mxunit.framework.TestCase" output="false" hint="I am a base class for all test case classes.">


	<!--- PRIVATE: --->


	<cffunction name="abort" returntype="void" access="private" output="false">
		<cfabort />
	</cffunction>


	<cffunction name="dump" returntype="void" access="private" output="true">
		<cfargument name="dumpData" type="any" required="true" />
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#arguments.dumpData#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>


</cfcomponent>