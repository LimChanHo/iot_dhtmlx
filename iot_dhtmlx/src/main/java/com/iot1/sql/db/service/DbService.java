package com.iot1.sql.db.service;

import java.util.List;
import java.util.Map;

import com.iot1.sql.db.dto.Column;
import com.iot1.sql.db.dto.DataBase;
import com.iot1.sql.db.dto.DbInfo;
import com.iot1.sql.db.dto.Table;
  
public interface DbService {
	public List<DbInfo> getDbInfoList(DbInfo di);
	public List<DataBase> getDataBaseList() throws Exception;
	public boolean isConnecteDB(DbInfo pDi) throws Exception;
	public List<Table> getTableList(DataBase di) throws Exception;
	public List<Column> getTableInfo(Table tableName) throws Exception;
	public Map<String,Object> runSql(Map<String, String> pm) throws Exception;

}
