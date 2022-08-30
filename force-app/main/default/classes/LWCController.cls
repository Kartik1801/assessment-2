public with sharing class LWCController {
    
    @AuraEnabled(cacheable=true)
    public static List<CompanyC__c> getCompanyDetails(){
        try {
            return [SELECT Name, Name__c, Total_No_of_Deals__c, Description__c, External_Last_Modified_DateTime__c, Company_External_System_Id__c FROM CompanyC__c ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void  saveRecord(CompanyC__c company, ContactC__c contact, DealC__c deal){
        try {
            String random = DateTIme.now().formatLong();
            CompanyC__c companyRef = new CompanyC__c(Company_External_System_Id__c = 'c' + random);
            company.Company_External_System_Id__c = random;
            ContactC__c contactRef = new ContactC__c(Contact_External_System_Id__c = random + 'c');
            contact.Company__r = companyRef;
            contact.Contact_External_System_Id__c = random + 'c';
            deal.Contact__r = contactRef;
            deal.Company__r = companyRef;

            Database.SaveResult[] r = Database.insert(new SObject[] { company, contact, deal },false);
            System.debug(company);
            System.debug(contact);
            System.debug(deal);
            System.debug(r);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
