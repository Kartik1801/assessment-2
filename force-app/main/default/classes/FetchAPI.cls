@RestResource(urlMapping='/data')
global with sharing class FetchAPI {
    @httpPost
    global static String pushData(){
        RestRequest req = RestContext.request;
        String reqBody = req.requestBody.toString();        
        RequestParser reqResource = (RequestParser) JSON.deserialize(reqBody, RequestParser.class);
        
        // Get Company that Matches the external ID Provided:
        List<CompanyC__c> companyList = [ SELECT Company_External_System_Id__c, External_Last_Modified_DateTime__c, Name__c, Description__c, OwnerId FROM CompanyC__c 
            WHERE Company_External_System_Id__C = :reqResource.company.company_external_system_id LIMIT 1];
        
        List<String> dealExtIDs = new List<String>();
        List<String> contactExtIDS = new List<String>();

        // populating list of external id for deals : 
        for ( RequestParser.DealClass deal:  reqResource.company.deals){
            dealExtIDs.add(deal.deal_external_system_id);
        }
        // populating list of external id for contacts : 
        for ( RequestParser.ContactClass contact:  reqResource.company.contacts){
            contactExtIDS.add(contact.contact_external_system_id);
        }

        Map<String, DealC__c> dealMap = new Map<String, DealC__c>();
        Map<String, ContactC__c> contactMap = new Map<String, ContactC__c>();
        
        // Check wether the deals provided along with company exist or not;
        for (DealC__c deals: [ SELECT Deal_External_System_Id__c, Name__c, Amount__c, Description__c, External_Last_Modified_DateTime__c, Company__c, Contact__c FROM DealC__c
             WHERE Deal_External_System_Id__c IN :dealExtIDs ]){
                dealMap.put(deals.Deal_External_System_Id__c, deals);
        }
        // Check wether the contacts provided along with company exist or not;
        for (ContactC__c contacts: [ SELECT Contact_External_System_Id__c, Name, Description__c, External_Last_Modified_DateTime__c, Company__c FROM ContactC__c
             WHERE Contact_External_System_Id__c IN :contactExtIDS ]){
                contactMap.put(contacts.Contact_External_System_Id__c, contacts);
        }
        // To be upserted.
        List<DealC__c> dealList = new List<DealC__c>();
        List<ContactC__c> conList = new List<ContactC__c>();
        CompanyC__c company;

        CompanyC__c companyRef = new CompanyC__c(Company_External_System_Id__c = reqResource.company.company_external_system_id);
        // Company
        if (companyList.size() == 0){
            // If company doesnt exist in SF 
            company = new CompanyC__c( Company_External_System_Id__c = reqResource.company.company_external_system_id, Name__c = reqResource.company.name, 
                External_Last_Modified_DateTime__c = reqResource.company.external_last_modified_datetime, Description__c = reqResource.company.description );                                                                
        }                         
        else{
           // If company exists in SF.
           company = companyList[0];
           if (company.External_Last_Modified_DateTime__c < reqResource.company.external_last_modified_datetime){
                company.Name__c = reqResource.company.name;
                company.External_Last_Modified_DateTime__c = reqResource.company.external_last_modified_datetime;
                company.Description__c = reqResource.company.description;
                company.Company_External_System_Id__c = reqResource.company.company_external_system_id;
           } 
        }
        // contacts
        for( RequestParser.ContactClass contact : reqResource.company.contacts){
            if(contactMap.containsKey(contact.contact_external_system_id)){
                ContactC__c c =  contactMap.get(contact.contact_external_system_id);
                if( c.External_Last_Modified_DateTime__c < contact.external_last_modified_datetime ){
                    c.Name = contact.name;
                    c.description__c = contact.description;
                    c.Contact_External_System_Id__c = contact.contact_external_system_id;
                    c.Company__r = companyRef;
                    c.External_Last_Modified_DateTime__c = contact.external_last_modified_datetime;
                }
                conList.add(c);
            }
            else{
                ContactC__c c =  new ContactC__c();
                c.Name = contact.name;
                c.description__c = contact.description;
                c.Contact_External_System_Id__c = contact.contact_external_system_id;
                c.Company__r = companyRef;
                c.External_Last_Modified_DateTime__c = contact.external_last_modified_datetime;
                conList.add(c);
            }
        }
        // deals
        for ( RequestParser.DealClass deal : reqResource.company.deals){
            if(dealMap.containsKey(deal.deal_external_system_id)){
                DealC__c d = dealMap.get(deal.deal_external_system_id);
                if ( d.External_Last_Modified_DateTime__c < deal.external_last_modified_datetime ){
                    d.Name__c = deal.name;
                    d.Amount__c = (Decimal) deal.amount;
                    d.Company__r = companyRef;
                    d.External_Last_Modified_DateTime__c = deal.external_last_modified_datetime;
                    d.Contact__r = new ContactC__c( Contact_External_System_Id__c = deal.contact_person);
                    d.Description__c = deal.description;
                    d.Deal_External_System_Id__c = deal.deal_external_system_id;
            }
            dealList.add(d); 
        }
        else{
            DealC__c d = new DealC__c();
            d.Amount__c = (Decimal) deal.amount;
            d.Name__c  = deal.name;
            d.External_Last_Modified_DateTime__c = deal.external_last_modified_datetime;
            d.Company__r = companyRef;
            d.Contact__r = new ContactC__c( Contact_External_System_Id__c = deal.contact_person );
            d.Description__c = deal.description;
            d.Deal_External_System_Id__c = deal.deal_external_system_id;
            dealList.add(d); 
            }
        }

        Database.UpsertResult up = Database.upsert(company, false);
        Database.UpsertResult[] upc = Database.upsert(conList, false);
        Database.UpsertResult[] upd = Database.upsert(dealList, false);
        
        System.debug(up);
        System.debug(upc);
        System.debug(upd);
        return 'OK';
    }
}
