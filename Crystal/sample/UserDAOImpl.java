package pkg.impl;

import java.sql.Types;
import java.util.List;
import java.util.Date;
import java.util.Calendar;
import java.text.SimpleDateFormat;


/**
 * Database access layer
 * 
 */
public class UserDAOImpl extends DAOUtils implements UserDAO
{
	private static final long serialVersionUID = 1L;
	private static final String CREATE =  "Insert into USER (created_by, pk_id,user_type,first_name,last_name,location_id,nt_id,phone,email,active,employee_id,employee_name,contractor_id,contractor_name,company_id) values (?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	private static final String DELETE = "Update PK_ID set ACTIVE_IND = 'N', DATE_MODIFIED = ?, MODIFIED_BY = ?, UPDATE_CNT = ? where pk_id= ? and UPDATE_CNT = ?";
	private static final String READ = "Select * from PK_ID where pk_id= ?";
	private static final String UPDATE = "Update PK_ID set ACTIVE_IND = 'Y', DATE_MODIFIED = ?, MODIFIED_BY = ?, UPDATE_CNT = ?, pk_id= ?, user_type= ?, first_name= ?, last_name= ?, location_id= ?, nt_id= ?, phone= ?, email= ?, active= ?, employee_id= ?, employee_name= ?, contractor_id= ?, contractor_name= ?, company_id= ? where pk_id= ? and UPDATE_CNT = ?";
	private static final String LIST = "Select * from USER ";
	private static final String VIEW = "Select * from USER_VIEW  ";
	private static final String SEARCH = "Select * from USER_VIEW where ACTIVE_IND = 'Y' ";
	private static final String DUP_CHECK = "Select * from USER_VIEW where ACTIVE_IND = ACTIVE_IND ";

	public int createUser(User user)
	{
		SimpleDateFormat sdf  = new SimpleDateFormat("yyyy/MM/dd");
		if( user.getActive() == null || active.getActive().equals("") ) user.setActive( "Y" );
		getJdbcTemplate().update(CREATE
			, new Object[] {user.getCreatedBy(), user.getPk_id(),user.getUser_type(),user.getFirst_name(),user.getLast_name(),user.getLocation_id(),user.getNt_id(),user.getPhone(),user.getEmail(),user.getActive(),user.getEmployee_id(),user.getEmployee_name(),user.getContractor_id(),user.getContractor_name(),user.getCompany_id()}
			, new int[] {Types.INTEGER,Types.INTEGER,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER});
		return(0);
	}

	public List<User> listUser()
	{
		return getJdbcTemplate().query(LIST, new UserRowMapper());
	}

	public List<UserView> dupCheckUser(UserView user, Long rowFrom, Long rowTo)
	{
		Long n;
		String s;
		String sql = DUP_CHECK;
		n = user.getPk_id();
		if(n != null && (n != 0) ) sql = sql + "and PK_ID != '" + n + "' ";
		s = user.getUser_type();
		if(s != null && (!s.equals(""))  ) sql = sql + "and USER_TYPE = '" + s + "' ";
		s = user.getFirst_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(FIRST_NAME) = UPPER('" + s + "') ";
		s = user.getLast_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(LAST_NAME) = UPPER('" + s + "') ";
		n = user.getLocation_id();
		if(n != null && (n != 0) ) sql = sql + "and LOCATION_ID = '" + n + "' ";
		s = user.getNt_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(NT_ID) = UPPER('" + s + "') ";
		s = user.getPhone();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(PHONE) = UPPER('" + s + "') ";
		s = user.getEmail();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(EMAIL) = UPPER('" + s + "') ";
		s = user.getActive();
		if(s != null && (!s.equals(""))  ) sql = sql + "and ACTIVE = '" + s + "' ";
		s = user.getEmployee();
		if(s != null && (!s.equals("")) ) sql = sql + "and EMPLOYEE = '" + s + "' ";
		s = user.getEmployee_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and EMPLOYEE_ID = '" + s + "' ";
		s = user.getContractor_employee();
		if(s != null && (!s.equals("")) ) sql = sql + "and CONTRACTOR_EMPLOYEE = '" + s + "' ";
		s = user.getContractor_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and CONTRACTOR_ID = '" + s + "' ";
		n = user.getCompany_id();
		if(n != null && (n != 0) ) sql = sql + "and COMPANY_ID = '" + n + "' ";
		return getJdbcTemplate().query(sql, new UserViewRowMapper());
	}

	public List<UserView> searchUser(UserView user, Long rowFrom, Long rowTo)
	{
		Long n;
		String s;
		String sql = SEARCH;
		n = user.getPk_id();
		if(n != null && (n != 0) ) sql = sql + "and PK_ID = '" + n + "' ";
		s = user.getUser_type();
		if(s != null && (!s.equals(""))  ) sql = sql + "and USER_TYPE = '" + s + "' ";
		s = user.getFirst_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(FIRST_NAME) = UPPER('" + s + "') ";
		s = user.getLast_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(LAST_NAME) = UPPER('" + s + "') ";
		n = user.getLocation_id();
		if(n != null && (n != 0) ) sql = sql + "and LOCATION_ID = '" + n + "' ";
		s = user.getNt_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(NT_ID) = UPPER('" + s + "') ";
		s = user.getPhone();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(PHONE) = UPPER('" + s + "') ";
		s = user.getEmail();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(EMAIL) = UPPER('" + s + "') ";
		s = user.getActive();
		if(s != null && (!s.equals(""))  ) sql = sql + "and ACTIVE = '" + s + "' ";
		s = user.getEmployee();
		if(s != null && (!s.equals("")) ) sql = sql + "and EMPLOYEE = '" + s + "' ";
		s = user.getEmployee_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and EMPLOYEE_ID = '" + s + "' ";
		s = user.getEmployee_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(EMPLOYEE_NAME) like UPPER('" + s + "%') ";
		s = user.getContractor_employee();
		if(s != null && (!s.equals("")) ) sql = sql + "and CONTRACTOR_EMPLOYEE = '" + s + "' ";
		s = user.getContractor_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and CONTRACTOR_ID = '" + s + "' ";
		s = user.getContractor_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(CONTRACTOR_NAME) like UPPER('" + s + "%') ";
		n = user.getCompany_id();
		if(n != null && (n != 0) ) sql = sql + "and COMPANY_ID = '" + n + "' ";
		sql = sql + " order by ACTIVE_STATUS, NT_ID";
		return getJdbcTemplate().query(sql, new UserViewRowMapper());
	}

	public List<UserView> viewUser(String filter, Long id, String flags)
	{
		String s = "ACTIVE_IND = 'Y'";
		if(filter != null && filter.length() != 0) s = s + " and " + filter;
		if(id != null && id != 0) s = " pk_id = '" + id + "' or ( " + s + " )";
		return getJdbcTemplate().query(VIEW + " where " + s + " " + flags, new UserViewRowMapper());
	}

	public User readUser(Long pk_id)
	{
		List<User> list =  getJdbcTemplate().query(READ, new Object[]{pk_id}, new Pk_idRowMapper());
		if(list != null && list.size() > 0)
		{
			return list.get(0);
		}
		return null;
	}

	public int updateUser(User user)
	{
		SimpleDateFormat sdf  = new SimpleDateFormat("yyyy/MM/dd");
		if( user.getActive() == null || active.getActive().equals("") ) user.setActive( "Y" );
		Long newUpdateCnt = user.getUpdateCnt() + 1;
		return( getJdbcTemplate().update(UPDATE, new Object[]{ new Date(), user.getModifiedBy(), newUpdateCnt, user.getPk_id(), user.getUser_type(), user.getFirst_name(), user.getLast_name(), user.getLocation_id(), user.getNt_id(), user.getPhone(), user.getEmail(), user.getActive(), user.getEmployee_id(), user.getEmployee_name(), user.getContractor_id(), user.getContractor_name(), user.getCompany_id(), user.getPk_id(), user.getUpdateCnt()}));
	}

	public int deleteUser(User user)
	{
		Long newUpdateCnt = user.getUpdateCnt() + 1;
		return( getJdbcTemplate().update(DELETE, new Object[] { new Date(), user.getModifiedBy(), newUpdateCnt, user.getPk_id(), user.getUpdateCnt()}));
	}
	
	public static Date parseDate(String dateValue, SimpleDateFormat sdf) {
		
		Date newDate = null;
		
		if (dateValue != null) 
		{
			try 
			{
				newDate = sdf.parse(dateValue);
			} 
			catch (Exception pe) 
			{
			}
		}
		return newDate;
	}
}
