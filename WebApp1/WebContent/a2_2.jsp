<!-- Aufgabe 2.2: Visualisierung gemeinsam auftretender Hashtags als Netzwerkdiagramm -->
<!-- Autor: Philipp Schlechter -->
<!-- Datum: 30.06.2017 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.mit.*" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- START SIGMA IMPORTS -->
<script src="srct/sigma.core.js"></script>
<script src="srct/conrad.js"></script>
<script src="srct/utils/sigma.utils.js"></script>
<script src="srct/utils/sigma.polyfills.js"></script>
<script src="srct/sigma.settings.js"></script>
<script src="srct/classes/sigma.classes.dispatcher.js"></script>
<script src="srct/classes/sigma.classes.configurable.js"></script>
<script src="srct/classes/sigma.classes.graph.js"></script>
<script src="srct/classes/sigma.classes.camera.js"></script>
<script src="srct/classes/sigma.classes.quad.js"></script>
<script src="srct/classes/sigma.classes.edgequad.js"></script>
<script src="srct/captors/sigma.captors.mouse.js"></script>
<script src="srct/captors/sigma.captors.touch.js"></script>
<script src="srct/renderers/sigma.renderers.canvas.js"></script>
<script src="srct/renderers/sigma.renderers.webgl.js"></script>
<script src="srct/renderers/sigma.renderers.svg.js"></script>
<script src="srct/renderers/sigma.renderers.def.js"></script>
<script src="srct/renderers/webgl/sigma.webgl.nodes.def.js"></script>
<script src="srct/renderers/webgl/sigma.webgl.nodes.fast.js"></script>
<script src="srct/renderers/webgl/sigma.webgl.edges.def.js"></script>
<script src="srct/renderers/webgl/sigma.webgl.edges.fast.js"></script>
<script src="srct/renderers/webgl/sigma.webgl.edges.arrow.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.labels.def.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.hovers.def.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.nodes.def.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edges.def.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edges.curve.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edges.arrow.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edges.curvedArrow.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edgehovers.def.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edgehovers.curve.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edgehovers.arrow.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.edgehovers.curvedArrow.js"></script>
<script src="srct/renderers/canvas/sigma.canvas.extremities.def.js"></script>
<script src="srct/renderers/svg/sigma.svg.utils.js"></script>
<script src="srct/renderers/svg/sigma.svg.nodes.def.js"></script>
<script src="srct/renderers/svg/sigma.svg.edges.def.js"></script>
<script src="srct/renderers/svg/sigma.svg.edges.curve.js"></script>
<script src="srct/renderers/svg/sigma.svg.labels.def.js"></script>
<script src="srct/renderers/svg/sigma.svg.hovers.def.js"></script>
<script src="srct/middlewares/sigma.middlewares.rescale.js"></script>
<script src="srct/middlewares/sigma.middlewares.copy.js"></script>
<script src="srct/misc/sigma.misc.animation.js"></script>
<script src="srct/misc/sigma.misc.bindEvents.js"></script>
<script src="srct/misc/sigma.misc.bindDOMEvents.js"></script>
<script src="srct/misc/sigma.misc.drawHovers.js"></script>
<script src="plugins/sigma.layout.forceAtlas2/worker.js"></script>
<script src="plugins/sigma.layout.forceAtlas2/supervisor.js"></script>

<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Aufgabe 2.2: Visualisierung gemeinsam auftretender Hashtags als Netzwerkdiagramm</title>
	</head>
	
	
	<body>
		<!-- div, in dem der Graph gerendert wird -->
		<div id="container">
		  <style>
		    #graph-container {
		      top: 0;
		      bottom: 0;
		      left: 0;
		      right: 0;
		      position: absolute;
		    }
		  </style>
		  <div id="graph-container"></div>
		</div>
		
		<jsp:useBean id="obj" class="com.mit.HashtagBean"/>
		<jsp:setProperty property="*" name="obj"/>
		
		<%String ht = HashtagDAO.getHashtags();	//Hashtags
		String c = HashtagDAO.getConnections(); //Gemeinsam auftetende Hashtags%>
		
		<script type="text/javascript">
		
			//Leeren Graphen erstellen
			var s,
			g = {
			  nodes: [],
			  edges: []
			};
			
			// Knoten (Hashtags) hinzufuegen
			var hashtags = '<%=ht%>';
			var hashtagsArray = hashtags.split(";");
			var n = hashtagsArray.length;
			for(i = 0; i < hashtagsArray.length; i++){
				g.nodes.push({
					id: hashtagsArray[i],
					label: hashtagsArray[i],
					x: 100 * Math.cos(2 * i * Math.PI / n),
					y: 100 * Math.sin(2 * i * Math.PI / n),
					size: 0.5,
					color: '#666'
				});
			}
			
			// Kanten (gemeinsame Hashtags) hinzufuegen
			var connections = '<%=c%>';
			var connectionsArray = connections.split(";");
			for(i = 0; i < connectionsArray.length; i++){
				var connected = connectionsArray[i].split("+++");
				g.edges.push({
					id: connected[0] + "&" + connected[1]+i,
					source: connected[0],
					target: connected[1],
					size: 1,
					color: '#ccc'
				});
			}
			
			//Graphen erstellen:
			s = new sigma({
			  graph: g,
			  container: 'graph-container'
			});
			
			// Force Atlas zum Positionieren der Knoten
			s.startForceAtlas2({worker: true, barnesHutOptimize: false});
			setTimeout(function() { s.stopForceAtlas2(); },1000);
			
		</script>
	</body>
</html>