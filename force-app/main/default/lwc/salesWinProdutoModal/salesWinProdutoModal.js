import { api, track } from 'lwc';
import LightningModal from 'lightning/modal';
import getProductInfos from '@salesforce/apex/SalesWinProdutos.getProductInfos';
import * as helper from 'c/helper';

const fields = [
    { hide: true, required: true, fieldName: 'Product2Id',  value: ""},
    { hide: false, required: true, fieldName: 'ListPrice',  value: ""},
    { hide: false, required: true, fieldName: 'TipoOperacao__c',  value: ""},
    { hide: false, required: true, fieldName: 'Quantity',  value: 1},
    { hide: false, required: true, fieldName: 'UnitPrice',  value: ''},
    { hide: false, required: true, fieldName: 'Discount',  value: 0.0},
    { hide: true, required: true,  fieldName: 'PricebookEntryId', value: ''},
    { hide: true, required: true,  fieldName: 'Discount',  value: 0.0},
    { hide: true, required: true,  fieldName: 'QuoteId',  value: ''},
];


export default class SalesWinProdutoModal extends LightningModal {

    @api recordId; @api record; @api product2id;
    @track fields; msg;  productName; loading=false; scrollPosition;
    async connectedCallback() {

        this.scrollPosition = window.scrollY;

        this.loading = true;
        this.productInfos = await getProductInfos({productId: this.product2id});
        this.productName = this.productInfos.produto.Name;

        if(this.recordId){
            fields.forEach(field => {
                field.class = field.hide ? 'dnone' : 'flexWidth';
                delete field.value;
            });
            this.fields = fields;
            this.loading = false;
            return;
        }

        const recordDeepCopy = JSON.parse(JSON.stringify(this.record));
      
        const { MinimumQuantity__c } = this.productInfos.produto;
        if(MinimumQuantity__c){
            recordDeepCopy.Quantity = MinimumQuantity__c;
        }

        const myRecord = helper.keysToLower(recordDeepCopy);
        fields.forEach(field => {
            field.class = field.hide ? 'dnone' : 'flexWidth';
            field.value = myRecord[field.fieldName.toLowerCase()];
        });
        this.fields = fields;


        this.validateFields();
        this.loading = false;
    }

    validateFields() {
        this.msg = undefined; 
    
        this.fields.forEach(field => {
            const fieldName = field.fieldName.toLowerCase();
            const value = field.value;
            if(!value){return;}

            if (fieldName === 'quantity') {
                const { MinimumQuantity__c } = this.productInfos.produto;

                if (MinimumQuantity__c) {
                    const remainder = value % MinimumQuantity__c;
                    if (remainder !== 0) {
                        this.msg = `A Quantidade deve ser múltipla de ${MinimumQuantity__c}`;
                    }
                }
            }else if(fieldName === 'discount'){
                const { DscMax__c } = this.productInfos.controleProduto;
                if(value > DscMax__c) {
                    this.msg = `O Desconto deve ser menor ou igual a ${DscMax__c}`;
                }

            }
        });
    }

    handleChange(event){
    
        const fieldName = event.currentTarget.dataset.field.toLowerCase();
        const value = event.target.value;

        const finded = this.fields.find((element) => element.fieldName.toLowerCase() === fieldName);
        finded.value = value;
        this.validateFields();

    }


    handleSubmit(event){
        // event.preventDefault();
        this.loading = true;
        // const fields = event.detail.fields;
        // this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleError(event){
        this.loading = false;
    }

    handleSuccess(event) {
        const recordId = event.detail.id;

        const result = {
            ok: true,
            id: recordId
        }
        this.close(result);
    }

    get fraseBtn(){
        return this.recordId ? 'Salvar' : 'Adicionar';
    }

    get disableBtn(){
        return this.msg ? true : false;
    }

    closeAction() {
        this.close();

        window.scrollTo(0, this.scrollPosition);
    }

}