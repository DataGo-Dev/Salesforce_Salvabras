import { LightningElement, api } from "lwc";
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';

export default class SalesWin extends LightningElement {

    @api recordId; pricebooks; values = {};   
    async connectedCallback(){        
        this.pricebooks = await getPricebooks({recordId: this.recordId});
    }
    handleSelectValue(event){
        const value =  event.detail.value || event.target.value; 
        const key = event.currentTarget.dataset.key;
        this.values[key] = value;        
    }





}