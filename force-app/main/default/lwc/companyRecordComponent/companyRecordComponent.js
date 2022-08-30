import { LightningElement, track } from 'lwc';
import getCompanyDetails from '@salesforce/apex/LWCController.getCompanyDetails';
import saveRecord from '@salesforce/apex/LWCController.saveRecord';
const columns = [
    {
        label: "ACC ID",
        fieldName: "Name",
        cellAttribute: {
            class: {
                fieldName: 'cellColor'
            }
        }
    },
    {
        label: "External ID",
        fieldName: "Company_External_System_Id__c",
        cellAttribute: {
            class: {
                fieldName: 'cellColor'  
            }
        }
    },
    {
        label: "Name",
        fieldName: "Name__c",
        cellAttribute: {
            class: {
                fieldName: 'cellColor'
            }
        }
    },
    {
        label: "Description",
        fieldName: "Description__c",
        cellAttribute: {
            class: {
                fieldName: 'cellColor'
            }
        }
    },
    {
        label: "Total Number of Deals",
        fieldName: "Total_No_of_Deals__c",
        cellAttribute: {
            class: {
                fieldName: 'cellColor'
            }
        }
    }
]

export default class CompanyRecordComponent extends LightningElement {
    @track columns = columns;
    @track data = [];
    @track showModal = false;
    
    @track companyName;
    @track companyDescription;
    @track contactName;
    @track contactDescription;
    @track dealName;
    @track dealDescription;
    @track dealAmount;

    company = {};
    contact = {};
    deal = {};

    handleModal(){
        this.showModal = !this.showModal;
    }
    closeModal(){
        this.showModal = false;
    }

    handleSubmit(){
        this.companyName = this.template.querySelector('.companyName')
        this.companyDescription = this.template.querySelector('.companyDescription')
        this.contactName = this.template.querySelector('.contactName')
        this.contactDescription = this.template.querySelector('.contactDescription')
        this.dealName = this.template.querySelector('.dealName')
        this.dealDescription = this.template.querySelector('.dealDescription')
        this.dealAmount = this.template.querySelector('.dealAmount')
        this.company.Name__c = this.companyName.value;
        this.company.Description__c = this.companyDescription.value;
        this.contact.Name = this.contactName.value;
        this.contact.description__c = this.contactDescription.value;
        this.deal.Name__c = this.dealName.value;
        this.deal.Description__c = this.dealDescription.value;
        this.deal.Amount__c = this.dealAmount.value;
        console.log(this.company);
        console.log(this.contact);
        console.log(this.deal);
        saveRecord({company: this.company, contact: this.contact, deal: this.deal})
        .then(() => this.showModal = false)
        .catch(e => console.log(e.message)) 
    }

    connectedCallback(){
        getCompanyDetails()
            .then((data) => {
                this.data = data;
            })
    }

}