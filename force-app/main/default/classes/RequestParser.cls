public with sharing class RequestParser {
    public companyClass company; 
    public class CompanyClass{
        public String name;
        public String description;
        public String company_external_system_id;
        public DateTime external_last_modified_datetime;
        public DealClass[] deals;
        public ContactClass[] contacts;
    }
    public class DealClass{
        public String name;
        public Decimal amount;
        public String description;
        public String contact_person;
        public String deal_external_system_id;
        public Datetime external_last_modified_datetime;
    } 
    public class ContactClass{
        public String name;
        public String description;
        public String contact_external_system_id;
        public Datetime external_last_modified_datetime;

    }
}
/* 
{
 "company":{
    "name": "Cyntexa",
    "description":"IT",
    "company_external_system_id":"1",
    "external_last_modified_datetime":"2022-08-20T10:00:00Z",
    "deals":[
        {
            "name":"First Contract",
            "amount":"20000000",
            "description":"Pending",
            "contact_person":"1",
            "deal_external_system_id":"1",
            "external_last_modified_datetime":"2022-08-20T10:10:00Z"
        },
        {
            "name":"Second Contract",
            "amount":"2112310",
            "description":"In Progress",
            "contact_person":"2",
            "deal_external_system_id":"2",
            "external_last_modified_datetime":"2022-08-15T10:30:00Z"
        }
    ],
    "contacts":[
        {
            "name":"Ajay",
            "description":"BA",
            "contact_external_system_id":"1",
            "external_last_modified_datetime":"2022-08-20T10:00:00Z"
        },
        {
            "name":"Amit",
            "description":"QA",
            "contact_external_system_id":"2",
            "external_last_modified_datetime":"2022-08-15T10:10:00Z"			
        }
	]
	}
}

*/