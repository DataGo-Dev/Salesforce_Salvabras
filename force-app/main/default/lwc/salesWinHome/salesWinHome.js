import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";

export default class SalesWinHome extends NavigationMixin(LightningElement) {

    @api recordId;

    pricebooks; pricebookValue; loading=false; 
    async connectedCallback(){     
        this.pricebooks = await getPricebooks({recordId: this.recordId});
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