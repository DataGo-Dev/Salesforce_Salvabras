import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import getProductInfos from '@salesforce/apex/SalesWinProdutos.getProductInfos';
import * as helper from 'c/helper';

const fields = [
    { hide: false, required: true,  disabled: true, fieldName: 'Product2Id',  value: ""},
    { hide: false, required: true,  disabled: true, fieldName: 'ListPrice',  value: ""},
    { hide: false, required: true,  disabled: false, fieldName: 'TipoOperacao__c',  value: ""},
    { hide: false, required: true,  disabled: false, fieldName: 'Quantity',  value: 1},
    { hide: false, required: true,  disabled: false, fieldName: 'UnitPrice',  value: ''},
    { hide: false, required: true,  disabled: false, fieldName: 'Discount',  value: 0.0},

    { hide: true, required: true,  disabled: true, fieldName: 'PricebookEntryId', value: ''},
    { hide: true, required: true,  disabled: true, fieldName: 'Discount',  value: 0.0},
    { hide: true, required: true,  disabled: true, fieldName: 'QuoteId',  value: ''},
];


export default class SalesWinProdutoModal extends LightningModal {

    @api recordId; @api record;
    fields=fields; msg;
    async connectedCallback() {

        const myRecord = helper.keysToLower(this.record);

        this.fields.forEach(field => {
            field.value = myRecord[field.fieldName.toLowerCase()];
        });

        const product2id = myRecord['product2id'];
        this.productInfos = await getProductInfos({productId: product2id});
        console.log(JSON.stringify(this.productInfos));

    }

    handleChange(event){
        this.msg = undefined;

        const fieldName = event.currentTarget.dataset.field.toLowerCase();
        const value = event.target.value;
        
        if(fieldName === 'quantity'){
            const {MinimumQuantity__c} = this.productInfos;            
            if(MinimumQuantity__c){
                const remainder = value % MinimumQuantity__c;
                if(remainder !== 0){
                    this.msg = `A Quantidade deve ser múltipla de ${MinimumQuantity__c}`;
                    return;
                }
            }
    
        }

    }

    get fraseBtn(){
        return this.recordId ? 'Salvar' : 'Adicionar';
    }

}