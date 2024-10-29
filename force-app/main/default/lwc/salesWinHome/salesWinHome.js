import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import getOpps from "@salesforce/apex/SalesWin.getOpps";
import * as helper from 'c/helper';

export default class SalesWinHome extends NavigationMixin(LightningElement) {

    @api recordId;

    pricebooks; pricebookValue; loadingPage=false; loading=false;
    opps; offset=0; pageSize=3;
    async connectedCallback(){     
        this.loading= true;
        this.pricebooks = await getPricebooks({recordId: this.recordId});
        await this.getOpps();
        this.loading= false;
    }

    showNextPageBtn = false;
    async getOpps(){
        this.loadingPage = true;
        const myOpps = await getOpps({accountId: this.recordId, offset: this.offset});

        this.offset += this.pageSize;
        this.showNextPageBtn = (myOpps.length >= this.pageSize);

        myOpps.forEach(el => {
                el.link = '/'+el.Id;
                el.createdByLink = '/'+el.CreatedById;
                el.f_createdDate = helper.formatDate(el.CreatedDate, false, true);
        });
        if(!this.opps){this.opps = [];}

        this.opps = [...this.opps, ...myOpps];
        this.loadingPage = false;
    }

    handleSelectValue(event){
        const value =  event.detail.value; 
        this.pricebookValue = value;  
    }

    showNewAla = false;
    handleClickNew(){
        this.showNewAla = !this.showNewAla;
        this.pricebookValue = undefined;   
    }

    continueToOpp(){

        const defaultValues = encodeDefaultFieldValues({
            Pricebook2Id: this.pricebookValue,
            StageName: 'Orçamento',
            AccountId: this.recordId
        });
    
    
        this[NavigationMixin.Navigate]({
                type: "standard__objectPage",
                attributes: {
                objectApiName: "Opportunity",
                actionName: "new",
            },
            state: {
                defaultFieldValues: defaultValues,
            },
        });

    }


    showToast(title, message, variant) {
        this.dispatchEvent(
          new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
          })
        );
    }


    get disableSave(){
        return this.pricebookValue === undefined;
    }


}