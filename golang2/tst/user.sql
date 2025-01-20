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
-----------------------------------------------------
   CREATE OR REPLACE VIEW User_VIEW
   (
    pk_id
   , user_type, User_typ
   , first_name
   , last_name
   , location_id, Location
   , nt_id
   , phone
   , email
   , active, Activ
   , employee_id, Employee
   , employee_name
   , contractor_id, Contractor_employee
   , contractor_name
   , company_id, Contractor_company
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    pk_id 
) User_typ
   , first_name 
   , last_name 
   , location_id, (Select location_name from Location where id = a.location_id) Location
   , nt_id 
   , phone 
   , email 
) Activ
   , employee_id, (Select ID from Employee where id = a.employee_id) Employee
(Select LAST_NAME || ' '  || FIRST_NAME from Employee where id = a.employee_id) employee_name
   , contractor_id, (Select id_number from Contractor_employee where id_number = a.contractor_id) Contractor_employee
(Select last_name || ' ' || first_name from Contractor_employee where id_number = a.contractor_id) contractor_name
   , company_id, (Select company_name from Contractor_company where pk_id = a.company_id) Contractor_company
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM User a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW User_typ_VIEW
   (
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM User_typ a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Location_VIEW
   (
    id
   , location_name
   , allowance_allowed
   , friendly_name
   , display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    id 
   , location_name 
   , allowance_allowed 
   , friendly_name 
$FWV as display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Location a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Activ_VIEW
   (
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Activ a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Employee_VIEW
   (
    id
   , first_name
   , last_name
   , sap_id
   , bp_level
   , location_id, Location
   , manager_id
   , nt_id
   , reports_to
   , active
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    id 
   , first_name 
   , last_name 
   , sap_id 
   , bp_level 
   , location_id, (Select ?Where_attr?:view.act:78,sample.def:65,Attr? from Location where ?Where_attr?:view.act:78,sample.def:65,Attr? = a.?Where_attr?:view.act:78,sample.def:65,Attr?) Location
   , manager_id 
   , nt_id 
   , reports_to 
   , active 
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Employee a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Contractor_employee_VIEW
   (
    pk_id
   , id_number
   , first_name
   , last_name
   , company_id, Contractor_company
   , location_id, Location
   , job_description
   , display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    pk_id 
   , id_number 
   , first_name 
   , last_name 
   , company_id, (Select ?Where_attr?:view.act:78,sample.def:79,Attr? from Contractor_company where ?Where_attr?:view.act:78,sample.def:79,Attr? = a.?Where_attr?:view.act:78,sample.def:79,Attr?) Contractor_company
   , location_id, (Select ?Where_attr?:view.act:78,sample.def:80,Attr? from Location where ?Where_attr?:view.act:78,sample.def:80,Attr? = a.?Where_attr?:view.act:78,sample.def:80,Attr?) Location
   , job_description 
$FWV as display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Contractor_employee a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Contractor_company_VIEW
   (
    pk_id
   , location_id, Location
   , company_rating_id, Company_rating
   , email_address
   , contact_person
   , service
   , display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    pk_id 
   , location_id, (Select ?Where_attr?:view.act:78,sample.def:90,Attr? from Location where ?Where_attr?:view.act:78,sample.def:90,Attr? = a.?Where_attr?:view.act:78,sample.def:90,Attr?) Location
   , company_rating_id, (Select ?Where_attr?:view.act:78,sample.def:91,Attr? from Company_rating where ?Where_attr?:view.act:78,sample.def:91,Attr? = a.?Where_attr?:view.act:78,sample.def:91,Attr?) Company_rating
   , email_address 
   , contact_person 
   , service 
$FWV as display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Contractor_company a 


-----------------------------------------------------
   CREATE OR REPLACE VIEW Company_rating_VIEW
   (
    pk_id
   , display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, ACTIVE_STATUS
   )
   AS
   SELECT 
    pk_id 
$FWV as display_fld
   , CREATED_BY, DATE_MODIFIED, UPDATE_CNT, ACTIVE_IND, DECODE(ACTIVE_IND, 'Y', 'Active', 'Inactive') AS ACTIVE_STATUS
   FROM Company_rating a 


Errors 36 15
