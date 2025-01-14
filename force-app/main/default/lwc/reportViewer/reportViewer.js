import { LightningElement, api } from 'lwc';
import savePdf from '@salesforce/apex/QuoteService.savePdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ReportViewer extends LightningElement {

    @api recordId;
    url;
    loading = false;

    connectedCallback(){
        this.url = `${window.location.origin}/apex/QuoteReport?id=${this.recordId}`;
    }

    get isMobile() {
        return /SalesforceMobile/i.test(window.navigator.userAgent);
    }

    async savePdf(){

        this.loading = true;
        const resp = await savePdf({
            recordId: this.recordId,
            reportName: 'QuoteReport',
            report: 'COTAÇÃO'
        });

        this.loading = false;
        if(resp){
            this.closeAction();
            this.showToast('PDF criado com sucesso!', 'success');
        }
      

    }

    showToast(message, variant) {
        const event = new ShowToastEvent({
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    closeAction() {
        const closeModalEvent = new CustomEvent("modalclose");
        this.dispatchEvent(closeModalEvent);
    }

    


}