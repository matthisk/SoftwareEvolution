module output::JSON

// LIBRARY IMPORTS
import Prelude;

// LOCAL IMPORTS
import Config;
import Volume;
import Util;

@doc{
	Outputs a JSON file for clone visualization
}
public void outputJSON( list[CloneClass] clones, map[str,value] meta, str filename = "" ) {
	json =  "{
			'	\"meta\" : {
			'		<if( "number_of_files" in meta ){>\"number_of_files\": <meta["number_of_files"]>,<}>
			'		<if( "lines_of_code" in meta )  {>\"lines_of_code\": <meta["lines_of_code"]>,<}>
			'		<if( "lines_of_clones" in meta ){>\"lines_of_clones\": <meta["lines_of_clones"]>,<}>
			'		<if( "created_at" in meta )     {>\"created_at\": \"<meta["created_at"]>\",<}>
			'		<if( "project_name" in meta )   {>\"project_name\": \"<meta["project_name"]>\",<}>
			'		<if( "elapsed_time" in meta )   {>\"elapsed_time\": \"<meta["elapsed_time"]>\"<}>
			'	},
			'	\"files\" : [
			'		<outputFiles( meta["file_locations"], meta["file_sizes"], meta["file_clone_sizes"] )>],
			'	\"clones\" : [
			'		<outputClones( clones )>	
			'	]
			'}";
	
	if( filename != "" ) {
		writeFile( toLocation( filename ), json );
	} else {
		if( "project_name" in meta && loc project := meta["project_name"] ) {
			mkDirectory(REPORT_LOCATION + project.authority);
			location = REPORT_LOCATION + project.authority + "report-<printDate(now(),"dd-MM-YYYY(hh:mm:ss)")>.json";
			writeFile( location, json );
		} else {
			location = REPORT_LOCATION + "report-<printDate(now(),"dd-MM-YYYY(hh:mm:ss)")>.json";
			writeFile( location, json );
		} 
		
	}
}

private str outputClones( list[CloneClass] clones ) {
	result = "";
	
	for( <s, class> <- clones ) {
		result += ",\n[";
		
		app = "";
		for( clone <- class ) {
			app += ",<outputLocation( clone )>";
		}
		
		result += substring(app, 1) + "]";
	}

	return substring(result,1);
}

private str outputFiles( value v, value b, value n ) { 
	if( list[loc] fs := v && list[int] sizes := b && list[int] cloneSizes := n ) {
		result = "";
		for( i <- [0..size(fs)] ) {
			result += ",{ \"location\": <outputLocation( fs[i] )>, \"lines_of_code\":<sizes[i]>, \"lines_of_clones\":<cloneSizes[i]> }
					  '";
		}
	
		return substring(result,1);
	} else {
		return "";
	} 
}

public str outputLocation( loc location ) {
	result = "{ ";
	
	try
		result += "\"scheme\": \"<location.scheme>\", ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"authority\": \"<location.authority>\", ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"path\": \"<location.path>\", ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"offset\": <location.offset>, ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"length\": <location.length>, ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"beginLine\": <location.begin.line>, ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"endLine\": <location.end.line>, ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"beginColumn\": <location.begin.column>, ";
	catch UnavailableInformation():
		result += "";
	try
		result += "\"endColumn\": <location.end.column>";
	catch UnavailableInformation():
		result += "";
	
	return result + " }";
}