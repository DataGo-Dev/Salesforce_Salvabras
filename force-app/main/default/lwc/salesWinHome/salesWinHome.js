import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';
import getOpps from "@salesforce/apex/SalesWin.getOpps";
import * as helper from 'c/helper';
import newOppModal from "c/salesWinNewOpp";
import { NavigationMixin } from "lightning/navigation";

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

    handleClickNew(){ 
        newOppModal.open({
            size: "small",
            recordId: this.recordId
        }).then(async (result) => {
            if (result?.ok) {
              this.showToast("Sucesso", "Registro gravado com sucesso!", "success");
              this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: result.id,
                    objectApiName: "Opportunity",
                    actionName: "view"
                }
            });
            }
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