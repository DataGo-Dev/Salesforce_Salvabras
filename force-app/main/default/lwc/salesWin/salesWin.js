import { api } from "lwc";
import LightningModal from 'lightning/modal';
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';

export default class SalesWin extends LightningModal {

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