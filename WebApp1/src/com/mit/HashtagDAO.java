package com.mit;
import java.sql.*;
import java.util.ArrayList;
import java.util.Iterator;

public class HashtagDAO {
	
	static Connection conn;
	static PreparedStatement stmt;
	static Statement stmtgetH;
	static Statement stmtgetC;
	static Statement stmtgetHC;
	static PreparedStatement pstmt;
	
//	Testmethode zum Erlernen des Inputs in Postgres via JSP
	public static int insertHashtag(HashtagBean u){
		int status = 0;
		try{
			conn = ConnectionProvider.getCon();
			stmt = conn.prepareStatement("INSERT INTO public.\"HashtagTest\" (htext) VALUES (?);");
			stmt.setString(1,u.getHashtag());
			status = stmt.executeUpdate();
			conn.close();
		}catch(Exception ex){
			System.out.println(ex);
		}
		return status;
	}
	
//	Gibt alle verwendeten Hashtags zurueck, um damit Knoten zu erstellen
	public static String getHashtags(){
		ArrayList<String> hashtags = new ArrayList<String>();
		try {
			conn = ConnectionProvider.getCon();
			stmtgetH = conn.createStatement();
			ResultSet rs = stmtgetH.executeQuery("SELECT DISTINCT \"htext\" FROM public.\"Hashtag\"");
			while(rs.next()){
				hashtags.add(rs.getString(1));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
//		Als Array parsen
		String hb = "";
		for (int i = 0; i < hashtags.size(); i++) {
			hb = hb + hashtags.get(i) + ";";
		}
		hb.substring(0, hb.length()-1);
		return hb.substring(0, hb.length()-1);
	}
	
//	Gibt jeweils 2er Paare zusammen verwendeter Hashtags zurueck
	public static String getConnections(){
		String c = "";
		ArrayList<String> connections = new ArrayList<String>();
		try {
			conn = ConnectionProvider.getCon();
			stmtgetC = conn.createStatement();
			ResultSet rs = stmtgetH.executeQuery("SELECT \"h1\", \"h2\" FROM public.\"commonHashtags\"");
			while(rs.next()){
				connections.add(rs.getString(1)+"+++"+rs.getString(2));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < connections.size(); i++) {
			c = c + connections.get(i) + ";";
		}
		return c.substring(0, c.length()-1);
	}
	
//	Gibt zu jedem Tag die Anzahl der verwendeten Hashtags zurueck
	public static String getHashtagCount(){
		String hc = "";
		ArrayList<Object> counts = new ArrayList<Object>();
		try {
			conn = ConnectionProvider.getCon();
			stmtgetHC = conn.createStatement();
			ResultSet rs = stmtgetHC.executeQuery("SELECT * FROM public.\"HashtagsPerDay\"");
			while(rs.next()){
				counts.add(rs.getDate(1)+"+++"+rs.getInt(2));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < counts.size(); i++) {
			hc = hc + counts.get(i) + ";";
		}
		return hc.substring(0, hc.length()-1);
	}
	
//	Gibt zu jedem Tag die Anzahl eines bestimmten verwendeten Hashtags zurueck
	public static String getSingleHashtagCount(String hashtag){
		String hc = "";
		ArrayList<Object> counts = new ArrayList<Object>();
		try {
			conn = ConnectionProvider.getCon();
			String sql = "SELECT t.\"time\", count(c.htext) AS counthashtags " +
						 "FROM \"Tweet\" t " +
						 "JOIN contains c " +
						 "ON t.\"TweetID\"::text = c.\"TweetID\"::text "+
						 "WHERE c.\"htext\" = ? " +
						 "GROUP BY t.\"time\" " +
						 "ORDER BY t.\"time\";";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, hashtag);
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()){
				counts.add(rs.getDate(1)+"+++"+rs.getInt(2));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < counts.size(); i++) {
			hc = hc + counts.get(i) + ";";
		}
		return hc.substring(0, hc.length()-1);
	}
}

