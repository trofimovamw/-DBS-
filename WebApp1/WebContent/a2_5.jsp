<!-- Aufgabe 2.4: Visualisierung der Haeufigkeit des Auftretens aller Hashtags im Zeitverlauf -->
<!-- Autor: Philipp Schlechter -->
<!-- Datum: 01.07.2017 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.mit.*" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- START IMPORTS -->
<script src="jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="jqplot/jquery.jqplot.min.js" type="text/javascript"></script>
<script type="text/javascript" src="jquery.canvasjs.min.js"></script>

<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Aufgabe 2.5 Visualisierung der Haeufigkeit des Auftretens eines auswählbaren Hashtags im Zeitverlauf</title>
	</head>
	
	<body>
		<div>
		<label>Bitte wählen Sie einen Hashtag aus</label>
		<select id="hSelect"></select>
		<button onclick="loadSingleHashtag()">Hashtag anzeigen</button>
		</div>
		<div>
   		<button onclick="showYear()">Gesamtes Jahr anzeigen</button>
   		</div>
		<!-- div, in dem das Diagramm gerendert wird -->
		<div>
			<style>
			    #graph-container {
			      top: 100;
			      bottom: 0;
			      left: 0;
			      right: 0;
			      position: absolute;
			    }
			 </style>	
      		<div id="chartContainer"></div>
   		</div>
   		
		
		<jsp:useBean id="obj" class="com.mit.HashtagBean"/>
		<jsp:setProperty property="*" name="obj"/>
		
		<%
		String ht = request.getParameter("hashtag");	// ausgewaehlter Hashtag
		String hc = HashtagDAO.getSingleHashtagCount(ht);  //Anzahl der Hashtags laden
		String hashtags = HashtagDAO.getHashtags();	// Hashtags fuer Select%>
		
		<script type="text/javascript">
		
		
		// Anzeigen des gesamten Jahres kommend von der Monatsperspektive
		function showYear(){
			location.reload();
		}
		
		// Anzeigen des ausgeaehlten Hashtags
		function loadSingleHashtag(){
			var e = document.getElementById("hSelect");
			window.open("http://localhost:8081/WebApp1/a2_5.jsp?hashtag="+e.options[e.selectedIndex].value);
		}
		
			window.onload = loadTags("MakeAmericaGreatAgain");
				
				
				function loadTags(tag) {
					
					// Werte in Select schreiben
					var htags =  '<%=hashtags%>'
					var tagArray = htags.split(";");
					for(i=0; i<tagArray.length; i++){
						var x = document.getElementById("hSelect");
						var option = document.createElement("option");
						option.text = tagArray[i];
						x.add(option); 
					}
					
					// Deafult Selektion auswaehlen
					$("#hSelect").val('<%=ht%>');
					
					
					//  Variablen zur Aggregation auf Monatsebene
						var monthCount = [0,0,0,0,0,0,0,0,0];
						var months = ["2016-01", "2016-02", "2016-03", "2016-04", "2016-05", "2016-06", "2016-07", "2016-08", "2016-09"]
					//  Variablen fuer Januar
						var janCount = [];
						var janDays = [];
					//  Variablen fuer Februar
						var febCount = [];
						var febDays = [];
					//  Variablen fuer Maerz
						var marCount = [];
						var marDays = [];
					//  Variablen fuer April
						var aprCount = [];
						var aprDays = [];
					//  Variablen fuer Mai
						var mayCount = [];
						var mayDays = [];
					//  Variablen fuer Juni
						var junCount = [];
						var junDays = [];
					//  Variablen fuer Juli
						var julCount = [];
						var julDays = [];
					//  Variablen fuer August
						var augCount = [];
						var augDays = [];
					//  Variablen fuer September
						var sepCount = [];
						var sepDays = [];
						
						var h = '<%=hc%>';
						hArray = h.split(";");
						for(i = 0; i<hArray.length; i++){
							var set = hArray[i].split("+++");
							var date = set[0];
							var count = set[1];
							// Anzahl auf Monatsebene aufaddieren und Monatsvariablen aufteilen
							if(date.substring(0,7) == "2016-01"){
								monthCount[0] += parseInt(count);
								janDays.push(date);
								janCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-02"){
								monthCount[1] += parseInt(count);
								febDays.push(date);
								febCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-03"){
								monthCount[2] += parseInt(count);
								marDays.push(date);
								marCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-04"){
								monthCount[3] += parseInt(count);
								aprDays.push(date);
								aprCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-05"){
								monthCount[4] += parseInt(count);
								mayDays.push(date);
								mayCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-06"){
								monthCount[5] += parseInt(count);
								junDays.push(date);
								junCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-07"){
								monthCount[6] += parseInt(count);
								julDays.push(date);
								julCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-08"){
								monthCount[7] += parseInt(count);
								augDays.push(date);
								augCount.push(parseInt(count));
							}else if(date.substring(0,7) == "2016-09"){
								monthCount[8] += parseInt(count);
								sepDays.push(date);
								sepCount.push(parseInt(count));
							}
							
						}

				//Diagramm fuer das ganze Jahr
					var options = {
						title: {
							text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf auf Monatsebene - Durch Klicken auf die Balken werden die einzelnen Monate angezeigt"
						},
				                animationEnabled: true,
						data: [
						{
							type: "column", //change it to line, area, bar, pie, etc
							click: onClick,
							dataPoints: [
								{ label: months[0], y: monthCount[0] },
								{ label: months[1], y: monthCount[1] },
								{ label: months[2], y: monthCount[2] },
								{ label: months[3], y: monthCount[3] },
								{ label: months[4], y: monthCount[4] },
								{ label: months[5], y: monthCount[5] },
								{ label: months[6], y: monthCount[6] },
								{ label: months[7], y: monthCount[7] },
								{ label: months[8], y: monthCount[8] }
							]
						}
						]
					};
				
				// Diagramm fuer Januar
					var jan = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Januar"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: janDays[0], y: janCount[0] },
									{ label: janDays[1], y: janCount[1] },
									{ label: janDays[2], y: janCount[2] },
									{ label: janDays[3], y: janCount[3] },
									{ label: janDays[4], y: janCount[4] },
									{ label: janDays[5], y: janCount[5] },
									{ label: janDays[6], y: janCount[6] },
									{ label: janDays[7], y: janCount[7] },
									{ label: janDays[8], y: janCount[8] },
									{ label: janDays[9], y: janCount[9] },
									{ label: janDays[10], y: janCount[10] },
									{ label: janDays[11], y: janCount[11] },
									{ label: janDays[12], y: janCount[12] },
									{ label: janDays[13], y: janCount[13] },
									{ label: janDays[14], y: janCount[14] },
									{ label: janDays[15], y: janCount[15] },
									{ label: janDays[16], y: janCount[16] },
									{ label: janDays[17], y: janCount[17] },
									{ label: janDays[18], y: janCount[18] },
									{ label: janDays[19], y: janCount[19] },
									{ label: janDays[20], y: janCount[20] },
									{ label: janDays[21], y: janCount[21] },
									{ label: janDays[22], y: janCount[22] },
									{ label: janDays[23], y: janCount[23] },
									{ label: janDays[24], y: janCount[24] }
								]
							}
							]
						};
					
					// Diagramm fuer Februar
					var feb = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Februar"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: febDays[0], y: febCount[0] },
									{ label: febDays[1], y: febCount[1] },
									{ label: febDays[2], y: febCount[2] },
									{ label: febDays[3], y: febCount[3] },
									{ label: febDays[4], y: febCount[4] },
									{ label: febDays[5], y: febCount[5] },
									{ label: febDays[6], y: febCount[6] },
									{ label: febDays[7], y: febCount[7] },
									{ label: febDays[8], y: febCount[8] },
									{ label: febDays[9], y: febCount[9] },
									{ label: febDays[10], y: febCount[10] },
									{ label: febDays[11], y: febCount[11] },
									{ label: febDays[12], y: febCount[12] },
									{ label: febDays[13], y: febCount[13] },
									{ label: febDays[14], y: febCount[14] },
									{ label: febDays[15], y: febCount[15] },
									{ label: febDays[16], y: febCount[16] },
									{ label: febDays[17], y: febCount[17] },
									{ label: febDays[18], y: febCount[18] },
									{ label: febDays[19], y: febCount[19] },
									{ label: febDays[20], y: febCount[20] },
									{ label: febDays[21], y: febCount[21] },
									{ label: febDays[22], y: febCount[22] },
									{ label: febDays[23], y: febCount[23] },
									{ label: febDays[24], y: febCount[24] },
									{ label: febDays[25], y: febCount[25] },
									{ label: febDays[26], y: febCount[26] },
									{ label: febDays[27], y: febCount[27] },
									{ label: febDays[28], y: febCount[28] }
								]
							}
							]
						};
					
					// Diagramm fuer Maerz
					var mar = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im März"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: marDays[0], y: marCount[0] },
									{ label: marDays[1], y: marCount[1] },
									{ label: marDays[2], y: marCount[2] },
									{ label: marDays[3], y: marCount[3] },
									{ label: marDays[4], y: marCount[4] },
									{ label: marDays[5], y: marCount[5] },
									{ label: marDays[6], y: marCount[6] },
									{ label: marDays[7], y: marCount[7] },
									{ label: marDays[8], y: marCount[8] },
									{ label: marDays[9], y: marCount[9] },
									{ label: marDays[10], y: marCount[10] },
									{ label: marDays[11], y: marCount[11] },
									{ label: marDays[12], y: marCount[12] },
									{ label: marDays[13], y: marCount[13] },
									{ label: marDays[14], y: marCount[14] },
									{ label: marDays[15], y: marCount[15] },
									{ label: marDays[16], y: marCount[16] },
									{ label: marDays[17], y: marCount[17] },
									{ label: marDays[18], y: marCount[18] },
									{ label: marDays[19], y: marCount[19] },
									{ label: marDays[20], y: marCount[20] },
									{ label: marDays[21], y: marCount[21] },
									{ label: marDays[22], y: marCount[22] },
									{ label: marDays[23], y: marCount[23] },
									{ label: marDays[24], y: marCount[24] },
									{ label: marDays[25], y: marCount[25] },
									{ label: marDays[26], y: marCount[26] },
									{ label: marDays[27], y: marCount[27] },
									{ label: marDays[28], y: marCount[28] },
									{ label: marDays[29], y: marCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer April
					var apr = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im April"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: aprDays[0], y: aprCount[0] },
									{ label: aprDays[1], y: aprCount[1] },
									{ label: aprDays[2], y: aprCount[2] },
									{ label: aprDays[3], y: aprCount[3] },
									{ label: aprDays[4], y: aprCount[4] },
									{ label: aprDays[5], y: aprCount[5] },
									{ label: aprDays[6], y: aprCount[6] },
									{ label: aprDays[7], y: aprCount[7] },
									{ label: aprDays[8], y: aprCount[8] },
									{ label: aprDays[9], y: aprCount[9] },
									{ label: aprDays[10], y: aprCount[10] },
									{ label: aprDays[11], y: aprCount[11] },
									{ label: aprDays[12], y: aprCount[12] },
									{ label: aprDays[13], y: aprCount[13] },
									{ label: aprDays[14], y: aprCount[14] },
									{ label: aprDays[15], y: aprCount[15] },
									{ label: aprDays[16], y: aprCount[16] },
									{ label: aprDays[17], y: aprCount[17] },
									{ label: aprDays[18], y: aprCount[18] },
									{ label: aprDays[19], y: aprCount[19] },
									{ label: aprDays[20], y: aprCount[20] },
									{ label: aprDays[21], y: aprCount[21] },
									{ label: aprDays[22], y: aprCount[22] },
									{ label: aprDays[23], y: aprCount[23] },
									{ label: aprDays[24], y: aprCount[24] },
									{ label: aprDays[25], y: aprCount[25] },
									{ label: aprDays[26], y: aprCount[26] },
									{ label: aprDays[27], y: aprCount[27] },
									{ label: aprDays[28], y: aprCount[28] },
									{ label: aprDays[29], y: aprCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer Mai
					var may = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Mai"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: mayDays[0], y: mayCount[0] },
									{ label: mayDays[1], y: mayCount[1] },
									{ label: mayDays[2], y: mayCount[2] },
									{ label: mayDays[3], y: mayCount[3] },
									{ label: mayDays[4], y: mayCount[4] },
									{ label: mayDays[5], y: mayCount[5] },
									{ label: mayDays[6], y: mayCount[6] },
									{ label: mayDays[7], y: mayCount[7] },
									{ label: mayDays[8], y: mayCount[8] },
									{ label: mayDays[9], y: mayCount[9] },
									{ label: mayDays[10], y: mayCount[10] },
									{ label: mayDays[11], y: mayCount[11] },
									{ label: mayDays[12], y: mayCount[12] },
									{ label: mayDays[13], y: mayCount[13] },
									{ label: mayDays[14], y: mayCount[14] },
									{ label: mayDays[15], y: mayCount[15] },
									{ label: mayDays[16], y: mayCount[16] },
									{ label: mayDays[17], y: mayCount[17] },
									{ label: mayDays[18], y: mayCount[18] },
									{ label: mayDays[19], y: mayCount[19] },
									{ label: mayDays[20], y: mayCount[20] },
									{ label: mayDays[21], y: mayCount[21] },
									{ label: mayDays[22], y: mayCount[22] },
									{ label: mayDays[23], y: mayCount[23] },
									{ label: mayDays[24], y: mayCount[24] },
									{ label: mayDays[25], y: mayCount[25] },
									{ label: mayDays[26], y: mayCount[26] },
									{ label: mayDays[27], y: mayCount[27] },
									{ label: mayDays[28], y: mayCount[28] },
									{ label: mayDays[29], y: mayCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer Juni
					var jun = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Juni"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: junDays[0], y: junCount[0] },
									{ label: junDays[1], y: junCount[1] },
									{ label: junDays[2], y: junCount[2] },
									{ label: junDays[3], y: junCount[3] },
									{ label: junDays[4], y: junCount[4] },
									{ label: junDays[5], y: junCount[5] },
									{ label: junDays[6], y: junCount[6] },
									{ label: junDays[7], y: junCount[7] },
									{ label: junDays[8], y: junCount[8] },
									{ label: junDays[9], y: junCount[9] },
									{ label: junDays[10], y: junCount[10] },
									{ label: junDays[11], y: junCount[11] },
									{ label: junDays[12], y: junCount[12] },
									{ label: junDays[13], y: junCount[13] },
									{ label: junDays[14], y: junCount[14] },
									{ label: junDays[15], y: junCount[15] },
									{ label: junDays[16], y: junCount[16] },
									{ label: junDays[17], y: junCount[17] },
									{ label: junDays[18], y: junCount[18] },
									{ label: junDays[19], y: junCount[19] },
									{ label: junDays[20], y: junCount[20] },
									{ label: junDays[21], y: junCount[21] },
									{ label: junDays[22], y: junCount[22] },
									{ label: junDays[23], y: junCount[23] },
									{ label: junDays[24], y: junCount[24] },
									{ label: junDays[25], y: junCount[25] },
									{ label: junDays[26], y: junCount[26] },
									{ label: junDays[27], y: junCount[27] },
									{ label: junDays[28], y: junCount[28] },
									{ label: junDays[29], y: junCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer Juli
					var jul = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Juli"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: julDays[0], y: julCount[0] },
									{ label: julDays[1], y: julCount[1] },
									{ label: julDays[2], y: julCount[2] },
									{ label: julDays[3], y: julCount[3] },
									{ label: julDays[4], y: julCount[4] },
									{ label: julDays[5], y: julCount[5] },
									{ label: julDays[6], y: julCount[6] },
									{ label: julDays[7], y: julCount[7] },
									{ label: julDays[8], y: julCount[8] },
									{ label: julDays[9], y: julCount[9] },
									{ label: julDays[10], y: julCount[10] },
									{ label: julDays[11], y: julCount[11] },
									{ label: julDays[12], y: julCount[12] },
									{ label: julDays[13], y: julCount[13] },
									{ label: julDays[14], y: julCount[14] },
									{ label: julDays[15], y: julCount[15] },
									{ label: julDays[16], y: julCount[16] },
									{ label: julDays[17], y: julCount[17] },
									{ label: julDays[18], y: julCount[18] },
									{ label: julDays[19], y: julCount[19] },
									{ label: julDays[20], y: julCount[20] },
									{ label: julDays[21], y: julCount[21] },
									{ label: julDays[22], y: julCount[22] },
									{ label: julDays[23], y: julCount[23] },
									{ label: julDays[24], y: julCount[24] },
									{ label: julDays[25], y: julCount[25] },
									{ label: julDays[26], y: julCount[26] },
									{ label: julDays[27], y: julCount[27] },
									{ label: julDays[28], y: julCount[28] },
									{ label: julDays[29], y: julCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer August
					var aug = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im August"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: augDays[0], y: augCount[0] },
									{ label: augDays[1], y: augCount[1] },
									{ label: augDays[2], y: augCount[2] },
									{ label: augDays[3], y: augCount[3] },
									{ label: augDays[4], y: augCount[4] },
									{ label: augDays[5], y: augCount[5] },
									{ label: augDays[6], y: augCount[6] },
									{ label: augDays[7], y: augCount[7] },
									{ label: augDays[8], y: augCount[8] },
									{ label: augDays[9], y: augCount[9] },
									{ label: augDays[10], y: augCount[10] },
									{ label: augDays[11], y: augCount[11] },
									{ label: augDays[12], y: augCount[12] },
									{ label: augDays[13], y: augCount[13] },
									{ label: augDays[14], y: augCount[14] },
									{ label: augDays[15], y: augCount[15] },
									{ label: augDays[16], y: augCount[16] },
									{ label: augDays[17], y: augCount[17] },
									{ label: augDays[18], y: augCount[18] },
									{ label: augDays[19], y: augCount[19] },
									{ label: augDays[20], y: augCount[20] },
									{ label: augDays[21], y: augCount[21] },
									{ label: augDays[22], y: augCount[22] },
									{ label: augDays[23], y: augCount[23] },
									{ label: augDays[24], y: augCount[24] },
									{ label: augDays[25], y: augCount[25] },
									{ label: augDays[26], y: augCount[26] },
									{ label: augDays[27], y: augCount[27] },
									{ label: augDays[28], y: augCount[28] },
									{ label: augDays[29], y: augCount[29] }
									
								]
							}
							]
						};
					
					// Diagramm fuer September
					var sep = {
							title: {
								text: "Häufigkeit des Hashtags \"#" + '<%=ht%>' + "\" im Zeitverlauf im Septemeber"
							},
					                animationEnabled: true,
							data: [
							{
								type: "column", //change it to line, area, bar, pie, etc
								dataPoints: [
									{ label: sepDays[0], y: sepCount[0] },
									{ label: sepDays[1], y: sepCount[1] },
									{ label: sepDays[2], y: sepCount[2] },
									{ label: sepDays[3], y: sepCount[3] },
									{ label: sepDays[4], y: sepCount[4] },
									{ label: sepDays[5], y: sepCount[5] },
									{ label: sepDays[6], y: sepCount[6] },
									{ label: sepDays[7], y: sepCount[7] },
									{ label: sepDays[8], y: sepCount[8] },
									{ label: sepDays[9], y: sepCount[9] },
									{ label: sepDays[10], y: sepCount[10] },
									{ label: sepDays[11], y: sepCount[11] },
									{ label: sepDays[12], y: sepCount[12] },
									{ label: sepDays[13], y: sepCount[13] },
									{ label: sepDays[14], y: sepCount[14] },
									{ label: sepDays[15], y: sepCount[15] },
									{ label: sepDays[16], y: sepCount[16] },
									{ label: sepDays[17], y: sepCount[17] },
									{ label: sepDays[18], y: sepCount[18] },
									{ label: sepDays[19], y: sepCount[19] },
									{ label: sepDays[20], y: sepCount[20] },
									{ label: sepDays[21], y: sepCount[21] },
									{ label: sepDays[22], y: sepCount[22] },
									{ label: sepDays[23], y: sepCount[23] },
									{ label: sepDays[24], y: sepCount[24] }
								]
							}
							]
						};
					
					// Durch klicken auf Balken den entsprechenden Monat anzeigen
					function onClick(e) {
						if(e.dataPoint.x == 0){
							$("#chartContainer").CanvasJSChart(jan);
						}else if(e.dataPoint.x == 1){
							$("#chartContainer").CanvasJSChart(feb);
						}else if(e.dataPoint.x == 2){
							$("#chartContainer").CanvasJSChart(mar);
						}else if(e.dataPoint.x == 3){
							$("#chartContainer").CanvasJSChart(apr);
						}else if(e.dataPoint.x == 4){
							$("#chartContainer").CanvasJSChart(may);
						}else if(e.dataPoint.x == 5){
							$("#chartContainer").CanvasJSChart(jun);
						}else if(e.dataPoint.x == 6){
							$("#chartContainer").CanvasJSChart(jul);
						}else if(e.dataPoint.x == 7){
							$("#chartContainer").CanvasJSChart(aug);
						}else if(e.dataPoint.x == 8){
							$("#chartContainer").CanvasJSChart(sep);
						}
					}

					$("#chartContainer").CanvasJSChart(options);

				}
		</script>
	</body>
</html>