table (Type_.) not found sample.def:5
table (Type_.) not found sample.def:7
table (Type_.) not found sample.def:8
table (Type_.) not found sample.def:10
table (Type_.) not found sample.def:11
table (Type_.) not found sample.def:12
table (Type_.) not found sample.def:43
table (Type_.) not found sample.def:44
table (Type_.) not found sample.def:45
table (Type_.) not found sample.def:46
table (Type_.) not found sample.def:47
table (Type_.) not found sample.def:60
table (Type_.) not found sample.def:61
table (Type_.) not found sample.def:62
table (Type_.) not found sample.def:63
table (Type_.) not found sample.def:64
table (Type_.) not found sample.def:66
table (Type_.) not found sample.def:67
table (Type_.) not found sample.def:68
table (Type_.) not found sample.def:69
table (Type_.) not found sample.def:75
table (Type_.) not found sample.def:76
table (Type_.) not found sample.def:77
table (Type_.) not found sample.def:78
table (Type_.) not found sample.def:81
table (Type_.) not found sample.def:82
table (Type_.) not found sample.def:88
table (Type_.) not found sample.def:89
table (Type_.) not found sample.def:92
table (Type_.) not found sample.def:93
table (Type_.) not found sample.def:94
table (Type_.) not found sample.def:95
table (Type_.) not found sample.def:101
table (Type_.) not found sample.def:102
table (Type_.) not found sample.def:103
attr (0_Attr_.) not found sample.def:27
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
)";
	private static final String DELETE = "Update pk_id set ACTIVE_IND = 'N', DATE_MODIFIED = ?, MODIFIED_BY = ?, UPDATE_CNT = ? where pk_id= ? and UPDATE_CNT = ?";
	private static final String READ = "Select * from pk_id where pk_id= ?";
 where pk_id= ? and UPDATE_CNT = ?";
	private static final String LIST = "Select * from User ";
	private static final String VIEW = "Select * from User_VIEW  ";
	private static final String SEARCH = "Select * from User_VIEW where ACTIVE_IND = 'Y' ";
	private static final String DUP_CHECK = "Select * from User_VIEW where ACTIVE_IND = ACTIVE_IND ";

	public int createUser(User User)
	{
		SimpleDateFormat sdf  = new SimpleDateFormat("yyyy/MM/dd");
		if( User.getactive() == null || active.getactive().equals("") ) User.setactive( "Y" );
		getJdbcTemplate().update(CREATE
}
});
		return(0);
	}

	public List<User> listUser()
	{
		return getJdbcTemplate().query(LIST, new UserRowMapper());
	}

	public List<UserView> dupCheckUser(UserView User, Long rowFrom, Long rowTo)
	{
		Long n;
		String s;
		String sql = DUP_CHECK;
		n = User.getpk_id();
		if(n != null && (n != 0) ) sql = sql + "and pk_id != '" + n + "' ";
		s = User.getuser_type();
		if(s != null && (!s.equals(""))  ) sql = sql + "and user_type = '" + s + "' ";
		s = User.getfirst_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(first_name) = UPPER('" + s + "') ";
		s = User.getlast_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(last_name) = UPPER('" + s + "') ";
		n = User.getlocation_id();
		if(n != null && (n != 0) ) sql = sql + "and location_id = '" + n + "' ";
		s = User.getnt_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(nt_id) = UPPER('" + s + "') ";
		s = User.getphone();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(phone) = UPPER('" + s + "') ";
		s = User.getemail();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(email) = UPPER('" + s + "') ";
		s = User.getactive();
		if(s != null && (!s.equals(""))  ) sql = sql + "and active = '" + s + "' ";
		s = User.getEmployee();
		if(s != null && (!s.equals("")) ) sql = sql + "and Employee = '" + s + "' ";
		s = User.getemployee_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and employee_id = '" + s + "' ";
		s = User.getContractor_employee();
		if(s != null && (!s.equals("")) ) sql = sql + "and Contractor_employee = '" + s + "' ";
		s = User.getcontractor_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and contractor_id = '" + s + "' ";
		n = User.getcompany_id();
		if(n != null && (n != 0) ) sql = sql + "and company_id = '" + n + "' ";
		return getJdbcTemplate().query(sql, new UserViewRowMapper());
	}

	public List<UserView> searchUser(UserView User, Long rowFrom, Long rowTo)
	{
		Long n;
		String s;
		String sql = SEARCH;
		n = User.getpk_id();
		if(n != null && (n != 0) ) sql = sql + "and pk_id = '" + n + "' ";
		s = User.getuser_type();
		if(s != null && (!s.equals(""))  ) sql = sql + "and user_type = '" + s + "' ";
		s = User.getfirst_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(first_name) = UPPER('" + s + "') ";
		s = User.getlast_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(last_name) = UPPER('" + s + "') ";
		n = User.getlocation_id();
		if(n != null && (n != 0) ) sql = sql + "and location_id = '" + n + "' ";
		s = User.getnt_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(nt_id) = UPPER('" + s + "') ";
		s = User.getphone();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(phone) = UPPER('" + s + "') ";
		s = User.getemail();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(email) = UPPER('" + s + "') ";
		s = User.getactive();
		if(s != null && (!s.equals(""))  ) sql = sql + "and active = '" + s + "' ";
		s = User.getEmployee();
		if(s != null && (!s.equals("")) ) sql = sql + "and Employee = '" + s + "' ";
		s = User.getemployee_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and employee_id = '" + s + "' ";
		s = User.getemployee_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(employee_name) like UPPER('" + s + "%') ";
		s = User.getContractor_employee();
		if(s != null && (!s.equals("")) ) sql = sql + "and Contractor_employee = '" + s + "' ";
		s = User.getcontractor_id();
		if(s != null && (!s.equals("")) ) sql = sql + "and contractor_id = '" + s + "' ";
		s = User.getcontractor_name();
		if(s != null && (!s.equals("")) ) sql = sql + "and UPPER(contractor_name) like UPPER('" + s + "%') ";
		n = User.getcompany_id();
		if(n != null && (n != 0) ) sql = sql + "and company_id = '" + n + "' ";
";
		return getJdbcTemplate().query(sql, new UserViewRowMapper());
	}

	public List<UserView> viewUser(String filter, Long id, String flags)
	{
		String s = "ACTIVE_IND = 'Y'";
		if(filter != null && filter.length() != 0) s = s + " and " + filter;
		if(id != null && id != 0) s = " pk_id = '" + id + "' or ( " + s + " )";
		return getJdbcTemplate().query(VIEW + " where " + s + " " + flags, new UserViewRowMapper());
	}

pk_id)
	{
		List<User> list =  getJdbcTemplate().query(READ, new Object[]{pk_id}, new pk_idRowMapper());
		if(list != null && list.size() > 0)
		{
			return list.get(0);
		}
		return null;
	}

	public int updateUser(User User)
	{
		SimpleDateFormat sdf  = new SimpleDateFormat("yyyy/MM/dd");
		if( User.getactive() == null || active.getactive().equals("") ) User.setactive( "Y" );
		Long newUpdateCnt = User.getUpdateCnt() + 1;
, User.getpk_id(), User.getUpdateCnt()}));
	}

	public int deleteUser(User User)
	{
		Long newUpdateCnt = User.getUpdateCnt() + 1;
		return( getJdbcTemplate().update(DELETE, new Object[] { new Date(), User.getModifiedBy(), newUpdateCnt, User.getpk_id(), User.getUpdateCnt()}));
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
Errors 36 0
