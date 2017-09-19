package com.iot1.sql.db.dto;

import org.springframework.stereotype.Component;

@Component
  
public class DbInfo{
	
	private int diNum;
	private int uiNum;
	private String dbUrl;
	private String port;
	private String dbms;
	private String dbTitle;
	private String id;
	private String pwd;
	private String driverName;
	
	public int getDiNum() {
		return diNum;
	}
	public void setDiNum(int diNum) {
		this.diNum = diNum;
	}
	public int getUiNum() {
		return uiNum;
	}
	public void setUiNum(int uiNum) {
		this.uiNum = uiNum;
	}
	public String getDbUrl() {
		return dbUrl;
	}
	public void setDbUrl(String dbUrl) {
		this.dbUrl = dbUrl;
	}
	public String getPort() {
		return port;
	}
	public void setPort(String port) {
		this.port = port;
	}
	public String getDbms() {
		return dbms;
	}
	public void setDbms(String dbms) {
		this.dbms = dbms;
	}
	public String getDbTitle() {
		return dbTitle;
	}
	public void setDbTitle(String dbTitle) {
		this.dbTitle = dbTitle;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getDriverName() {
		return driverName;
	}
	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
	@Override
	public String toString() {
		return "DbInfo [diNum=" + diNum + ", uiNum=" + uiNum + ", dbUrl=" + dbUrl + ", port=" + port + ", dbms=" + dbms
				+ ", dbTitle=" + dbTitle + ", id=" + id + ", pwd=" + pwd + ", driverName=" + driverName + "]";
	}
	
}
