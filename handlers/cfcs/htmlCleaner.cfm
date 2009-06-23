<!---cd C:\JRun4\servers\funstuff\cfusion.ear\cfusion.war\cifusion\checkstyle
java -jar checkstyle-all-5.0.jar \ -c cf_checks_dups.xml \ -f xml -o checkstyle_errors.xml -r C:\JRun4\servers\funstuff\cfusion.ear\cfusion.war\cfspec
--->

<cfsavecontent variable="test">
<table id=table1 cellspacing=2px
    <h1>CONTENT</h1>
    <td><a href=index.html>1 -> Home Page</a>
    <td><a href=intro.html>2 -> Introduction</a
</cfsavecontent>

<cffile action="read" file="C:\JRun4\servers\funstuff\cfusion.ear\cfusion.war\CodeCop\about.cfm" variable="test" >
<cfscript>
	paths = arrayNew(1);
	/*
	This points to the jar we want to load.
	Could also load a directory of .class files
	*/
	paths[1] = expandPath("lib\htmlcleaner2_1.jar");
	
	//create the loader
	loader = createObject("component", "cifusion.jl.javaloader.JavaLoader").init(paths);
	
	// create an instance of HtmlCleaner
	cleaner = loader.create("org.htmlcleaner.HtmlCleaner");
	transformations = loader.create("org.htmlcleaner.CleanerTransformations");
	TagTransformation = loader.create("org.htmlcleaner.TagTransformation");
	// take default cleaner properties CleanerProperties 
	props = cleaner.getProperties();
	// Clean HTML taken from simple string, file, URL, input stream, 
	// input source or reader. Result is root node of created 
	// tree-like structure. Single cleaner instance may be safely used 
	// multiple times. TagNode node = 
	// CleanerTransformations transformations = new CleanerTransformations();
	tt = TagTransformation.init("cfoutput");
	tt2 = transformations.addTransformation(tt);
	
	tt = TagTransformation.init("c:block", "div", false);
	tt2 = transformations.addTransformation(tt);
		
	node = cleaner.clean(test);
	myNode = cleaner.getInnerHtml(node);
	
	cleaner.setTransformations(transformations);
</cfscript> 
<cfdump var="#myNode#">
