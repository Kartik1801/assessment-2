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
            System.debug(company);
            System.debug(contact);
            System.debug(deal);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
