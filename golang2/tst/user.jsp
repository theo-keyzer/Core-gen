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
<%@ include file="/WEB-INF/jsp/include.jsp" %>

<div class="portlet-section-header"></div>

<div class="portlet-section-body">
	
	<portlet:actionURL var="submitActionUrl">
		<portlet:param name="action" value="submitNewForm"/>
	</portlet:actionURL>

>
		
		<form:hidden pk_id="submitAction" path="submitAction"/>
		
		<div><form:errors cssClass="portlet-msg-error" path="*" /></div>		
		
		<table border="0" cellpadding="4">
			<tr>
				<td class="portlet-form-field-label"><spring:message code="User type"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="User.user_type" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
							<form:option value="1">Employee</form:option>
							<form:option value="2">Contractor employee</form:option>
							<form:option value="3">Contractor company</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="First name"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.first_name" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Last name"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.last_name" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Location"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="User.location_id" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
						<c:forEach var="LocationItem" items="${LocationItems}">
							<form:option value="${LocationItem.id}">${LocationItem.displayFld}</form:option>
						</c:forEach>
					</form:select>
				</td>
			</tr>	
			<tr>
				<td class="portlet-form-field-label"><spring:message code="NT id"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.nt_id" size="30" maxlength="255" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Phone"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.phone" size="30" maxlength="255" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Email"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.email" size="30" maxlength="255" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Active"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="User.active" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
							<form:option value="Y">Yes</form:option>
							<form:option value="N">No</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Employee number"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.employee_id" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Contractor reference number"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="User.contractor_id" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Company name"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="User.company_id" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
						<c:forEach var="Contractor_companyItem" items="${Contractor_companyItems}">
							<form:option value="${Contractor_companyItem.pk_id}">${Contractor_companyItem.displayFld}</form:option>
						</c:forEach>
					</form:select>
				</td>
			</tr>	
		</table>

		<br><br>
	
		<input type="submit" name="Save" value="<spring:message code="button.save.pkg.User"/>" onclick="javascript: UserForm_save_new();"/>&nbsp;&nbsp;
		<input type="submit" name="Cancel" value="<spring:message code="button.cancel.pkg.User"/>" onclick="javascript: UserForm_cancel();"/>
				
	</form:form>	
</div>

<div class="portlet-section-footer">
</div>

Errors 36 0
