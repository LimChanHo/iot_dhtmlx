package com.iot1.sql.db.dto;

import org.springframework.stereotype.Component;
  
@Component
public class DataBase{
	private String database;
	private String tableName;

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getDatabase() {
		return database;
	}

	public void setDatabase(String database) {
		this.database = database;
	}

	@Override
	public String toString() {
		return "DataBase [database=" + database + ", tableName=" + tableName + "]";
	}
}
