<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfif not isDefined('request.muraTemplateMissing')>
	<cfparam name="local" default="#structNew()#">
	<cfset local.pluginEvent="">

	<cflog type="Error" file="exception" text="#exception.stacktrace#">

	<cfif structKeyExists(application,"pluginManager") and structKeyExists(application.pluginManager,"announceEvent")>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset local.pluginEvent=request.servletEvent>
		<cfelseif structKeyExists(request,"event")>
			<cfset local.pluginEvent=request.event>
		<cfelse>
			<cftry>
			<cfset local.pluginEvent=createObject("component","mura.event")>
			<cfcatch></cfcatch>
			</cftry>
		</cfif>

		<cfif isObject(local.pluginEvent)>
			<cfset local.pluginEvent.setValue("exception",arguments.exception)>
			<cfset local.pluginEvent.setValue("eventname",arguments.eventname)>
			<cftry>
				<cfif len(local.pluginEvent.getValue("siteID"))>
					<cfset application.pluginManager.announceEvent("onSiteError",local.pluginEvent)>
				</cfif>
				<cfset application.pluginManager.announceEvent("onGlobalError",local.pluginEvent)>
				<cfcatch></cfcatch>
			</cftry>

		</cfif>
	</cfif>

	<cfif structKeyExists(application,"configBean")>
		<cftry>
		<cfif not application.configBean.getDebuggingEnabled()>
			<cfset mailto=application.configBean.getMailserverusername()>
			<cfcontent reset="true">
			<cfheader statuscode="500" statustext="An Error Occurred" />
			<cfif len(application.configBean.getValue("errorTemplate"))>
				<cfinclude template="#application.configBean.getValue('errorTemplate')#">
			<cfelse>
				<cfinclude template="/muraWRM/config/error.html">
			</cfif>
			<cfabort>
		</cfif>
		<cfcatch></cfcatch>
		</cftry>
	</cfif>
		<style type="text/css">
		.errorBox {
			margin: 10px auto 10px auto;
			width: 90%;
		}

		.errorBox h1 {
			font-size: 100px;
			margin: 5px 0px 5px 0px;
		}

		</style>
		<cfset knownErrorCheck = "0">
		<div class="errorBox">
			<img src="../../admin/assets/ico/apple-touch-icon-144-precomposed.png" />
			<h1>500 Error</h1>
			<cfif StructKeyExists(arguments.exception.Cause,"Message")>
				<cfif #arguments.exception.Cause.Message# CONTAINS "Datasource">
					<h2><cfoutput>#arguments.exception.Cause.Message#</cfoutput><br /></h2>
					<h3><cfoutput>Datasource: #arguments.exception.Cause.DataSource#</cfoutput><br /></h3>
					<pre><cfoutput>#arguments.exception.Cause.Cause.StackTrace#</cfoutput></pre><br />
						<cfloop array="#arguments.exception.Cause.TagContext#" index="errorContexts">
							<cfoutput>
							<hr />
							Column: #errorContexts.COLUMN#<br />
							ID: #errorContexts.ID#<br />
							Line: #errorContexts.LINE#<br />
							Raw Trace: #errorContexts.RAW_TRACE#<br />
							Template: #errorContexts.TEMPLATE#<br />
							Type: #errorContexts.TYPE#<br />
							<br />
							</cfoutput>
						</cfloop>
					<cfset knownErrorCheck = "1">
				</cfif>
			</cfif>
			<cfif StructKeyExists(arguments.exception.Cause,"Message")>
				<cfif #arguments.exception.Cause.Message# CONTAINS "Database">
					<h2><cfoutput>#arguments.exception.Cause.Cause.Cause.Message#</cfoutput><br /></h2>
					<h3><cfoutput>Datasource: #arguments.exception.Cause.DataSource#</cfoutput><br /></h3>
					<pre><cfoutput>#arguments.exception.Cause.Cause.Cause.StackTrace#</cfoutput></pre><br />
						<cfloop array="#arguments.exception.Cause.TagContext#" index="errorContexts">
							<cfoutput>
							<hr />
							Column: #errorContexts.COLUMN#<br />
							ID: #errorContexts.ID#<br />
							Line: #errorContexts.LINE#<br />
							Raw Trace: #errorContexts.RAW_TRACE#<br />
							Template: #errorContexts.TEMPLATE#<br />
							Type: #errorContexts.TYPE#<br />
							<br />
							</cfoutput>
						</cfloop>
					<cfset knownErrorCheck = "1">
				</cfif>
			</cfif>
			<cfif StructKeyExists(arguments.exception.Cause,"Action")>
				<cfif #arguments.exception.Cause.Action# CONTAINS "unzip">
					<h2><cfoutput>#arguments.exception.Cause.Cause.Message#</cfoutput><br /></h2>
					<pre><cfoutput>#arguments.exception.Cause.Cause.StackTrace#</cfoutput></pre><br />
						<cfloop array="#arguments.exception.Cause.TagContext#" index="errorContexts">
							<cfoutput>
							<hr />
							Column: #errorContexts.COLUMN#<br />
							ID: #errorContexts.ID#<br />
							Line: #errorContexts.LINE#<br />
							Raw Trace: #errorContexts.RAW_TRACE#<br />
							Template: #errorContexts.TEMPLATE#<br />
							Type: #errorContexts.TYPE#<br />
							<br />
							</cfoutput>
						</cfloop>
					<cfset knownErrorCheck = "1">
				</cfif>
			</cfif>
			<cfif StructKeyExists(arguments.exception.Cause,"Message")>
				<cfif #arguments.exception.Cause.Message# CONTAINS "already being used">
					<h2><cfoutput>#arguments.exception.Cause.Message#</cfoutput><br /></h2>
					<pre><cfoutput>#arguments.exception.Cause.StackTrace#</cfoutput></pre><br />
						<cfloop array="#arguments.exception.Cause.TagContext#" index="errorContexts">
							<cfoutput>
							<hr />
							Column: #errorContexts.COLUMN#<br />
							ID: #errorContexts.ID#<br />
							Line: #errorContexts.LINE#<br />
							Raw Trace: #errorContexts.RAW_TRACE#<br />
							Template: #errorContexts.TEMPLATE#<br />
							Type: #errorContexts.TYPE#<br />
							<br />
							</cfoutput>
						</cfloop>
					<cfset knownErrorCheck = "1">
				</cfif>
			</cfif>
			<cfif StructKeyExists(arguments.exception.Cause,"Message")>
				<cfif #arguments.exception.Cause.Message# CONTAINS "Could not find the included template">
					<h2><cfoutput>#arguments.exception.Cause.Message#</cfoutput><br /></h2>
					<h3><cfoutput>#arguments.exception.Cause.Detail#</cfoutput><br /></h3>
					<pre><cfoutput>#arguments.exception.Cause.StackTrace#</cfoutput></pre><br />
						<cfloop array="#arguments.exception.Cause.TagContext#" index="errorContexts">
							<cfoutput>
							<hr />
							Column: #errorContexts.COLUMN#<br />
							ID: #errorContexts.ID#<br />
							Line: #errorContexts.LINE#<br />
							Raw Trace: #errorContexts.RAW_TRACE#<br />
							Template: #errorContexts.TEMPLATE#<br />
							Type: #errorContexts.TYPE#<br />
							<br />
							</cfoutput>
						</cfloop>
					<cfset knownErrorCheck = "1">
				</cfif>
			</cfif>
			<cfif #knownErrorCheck# EQ "0">
				<cfdump var="#arguments.exception#" top="100">
			</cfif>
		<cfabort>
</cfif>