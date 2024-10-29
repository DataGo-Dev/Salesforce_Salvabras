import searchProducts from "@salesforce/apex/SalesWinProdutos.searchProducts";
import { LightningElement, api, track } from "lwc";

export default class SalesWinProdutos extends LightningElement {
    @api recordId;
    term = ""; searchTimeout; @track produtos;

    handleInputChange(event) {
		this.produtos = undefined;

        this.term = event.target.value.trim();
        clearTimeout(this.searchTimeout);

        if (this.term.length >= 2) {
            this.searchTimeout = setTimeout(() => {
                this.handleSearch();
            }, 300);
        }
    }

    async handleSearch() {
      
		const prods = await searchProducts({
			recordId: this.recordId,
			term: this.term
		});

		if(prods.length === 0) {
			this.produtos = undefined;
			return;
		}
		
		this.produtos = prods;
    }
}