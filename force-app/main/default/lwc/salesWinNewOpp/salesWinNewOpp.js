import { api, track } from "lwc";
import LightningModal from 'lightning/modal';
import getPricebooks from '@salesforce/apex/SalesWin.getPricebooks';
import saveOpp from "@salesforce/apex/SalesWin.saveOpp";


export default class SalesWin extends LightningModal {

    @api recordId; pricebooks; @track values = {sobjectType:'Opportunity'}; loading=false; msg;
    async connectedCallback(){     
        this.setLoading(true); 
        this.pricebooks = await getPricebooks({recordId: this.recordId});
        this.setLoading(false);
    }
    handleSelectValue(event){
        const value =  event.detail.value || event.target.value; 
        const key = event.currentTarget.dataset.key;
        this.values[key] = value;  
    }

    async saveOpp(){
        this.msg = undefined;
        
        this.setLoading(true);
        await saveOpp({opp: this.values}).then(resp => {
            
            const result = {
                ok: true
            }
    
            this.close(result);

        }).catch(err=>{
            this.msg = this.findMessage(err);
        });


        this.setLoading(false);

    
    }


    setLoading(param){
        this.loading=param;
    }



    findMessage(obj) {
        for (const key in obj) {
            if (obj.hasOwnProperty(key)) {
                if (key === 'message') {
                    return obj[key];
                } else if (typeof obj[key] === 'object' && obj[key] !== null) {
                    const result = this.findMessage(obj[key]); 
                    if (result) {
                        return result;
                    }
                }
            }
        }
        return null;
    }


    get disableSave(){
        const {Name, Pricebook2Id, StageName, CloseDate} = this.values;

        const isValid = (value) => {
            return value && value.trim() !== '';
        };
    

        return !isValid(Name) 
            || !isValid(Pricebook2Id) 
            || !isValid(StageName) 
            || !isValid(CloseDate);
    }


}