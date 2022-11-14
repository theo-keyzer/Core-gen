<%@ include file="/WEB-INF/jsp/include.jsp" %>

<div class="portlet-section-header"></div>

<div class="portlet-section-body">
	
	<portlet:actionURL var="submitActionUrl">
		<portlet:param name="action" value="submitNewForm"/>
	</portlet:actionURL>

	<form:form id="userForm" name="userForm" commandName="userForm" method="post" action="${submitActionUrl}" >
		
		<form:hidden pk_id="submitAction" path="submitAction"/>
		
		<div><form:errors cssClass="portlet-msg-error" path="*" /></div>		
		
		<table border="0" cellpadding="4">
			<tr>
				<td class="portlet-form-field-label"><spring:message code="User type"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="user.user_type" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
							<form:option value="1>Employee/form:option>
							<form:option value="2>Contractor employee/form:option>
							<form:option value="3>Contractor company/form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Location"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="user.location_id" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
						<c:forEach var="locationItem" items="${locationItems}">
							<form:option value="${locationItem.id}">${locationItem.displayFld}</form:option>
						</c:forEach>
					</form:select>
				</td>
			</tr>	
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Active"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="user.active" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
							<form:option value="Y>Yes/form:option>
							<form:option value="N>No/form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Employee number"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="user.employee_id" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Contractor reference number"/>&nbsp;&nbsp;</td>
				<td colspan="3"><form:input cssClass="portlet-form-input-field" path="user.contractor_id" size="30" maxlength="200" /></td>
			</tr>
			<tr>
				<td class="portlet-form-field-label"><spring:message code="Company name"/>&nbsp;&nbsp;</td>
				<td>
					<form:select cssClass="portlet-form-input-field" path="user.company_id" multiple="false" style="width: 18em;" size="1">
						<form:option value=""> </form:option>
						<c:forEach var="contractor_companyItem" items="${contractor_companyItems}">
							<form:option value="${contractor_companyItem.pk_id}">${contractor_companyItem.displayFld}</form:option>
						</c:forEach>
					</form:select>
				</td>
			</tr>	
		</table>

		<br><br>
	
		<input type="submit" name="Save" value="<spring:message code="button.save.pkg.user"/>" onclick="javascript: userForm_save_new();"/>&nbsp;&nbsp;
		<input type="submit" name="Cancel" value="<spring:message code="button.cancel.pkg.user"/>" onclick="javascript: userForm_cancel();"/>
				
	</form:form>	
</div>

<div class="portlet-section-footer">
</div>

