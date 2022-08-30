public with sharing class DealsTriggerHelperClass {
    public static void mailOnCreation(List<DealC__c> dealList){
        List<ID> companyIDList =  new List<ID>();
        List<ID> contactIDList = new List<Id>();
        for (DealC__c deal : dealList){
            if(deal.Deal_External_System_Id__c != null){
                companyIDList.add(deal.Company__c);
                contactIDList.add(deal.Contact__c);
            }
        }
        
        Map<Id,CompanyC__c> companyMap = new Map<ID,CompanyC__c>([ SELECT Name__c, Owner.email  FROM CompanyC__c Where ID IN :companyIDList ]);
        Map<Id,ContactC__c> contactMap = new Map<Id,ContactC__c>([ SELECT Name  From ContactC__c Where ID IN :contactIDList ]);
        
        for (DealC__c deal : dealList){
            if(deal.Deal_External_System_Id__c != null){
            
                String email = companyMap.get(deal.Company__c).Owner.email;
                String contactName = contactMap.get(deal.Contact__c).Name;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{email});
                mail.setSubject('New Deal Added');
                mail.setPlainTextBody('Hey there, \n A new deal " ' +deal.name__C + ' " is Added.  \n Please Contact ' + contactName + ' For more details');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});

            }
        }
        


    }
}
