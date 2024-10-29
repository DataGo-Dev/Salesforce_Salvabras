import searchProducts from "@salesforce/apex/SalesWinProdutos.searchProducts";
import { LightningElement, api, track } from "lwc";

export default class SalesWinProdutos extends LightningElement {
    @api recordId;
    term = ""; searchTimeout; @track produtos; selectedIndex = -1; 

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
		
		this.selectedIndex = -1;
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

	handleKeyDown(event) {

        const { key } = event;

        if (key === 'ArrowDown') {
            event.preventDefault(); 
            if (this.selectedIndex < this.produtos.length - 1) {
                this.selectedIndex++;
                this.updateSelection();
            }
        } else if (key === 'ArrowUp') {
            event.preventDefault();
            if (this.selectedIndex > 0) {
                this.selectedIndex--;
                this.updateSelection();
            }
        } else if (key === 'Enter') {
            event.preventDefault();
            if (this.selectedIndex > -1) {
			   const selectedItem = this.produtos[this.selectedIndex];
			   const evt ={ 
					currentTarget: { 
						dataset: { id: selectedItem.Id} 
					} 
				}
               this.hanldleClickItem(evt);
            }
        }
    }

    updateSelection() {
        const items = this.template.querySelectorAll('.itemBusca');
        items.forEach((item, index) => {
            const isSelected = index === this.selectedIndex;
            item.classList.toggle('selected', isSelected); 
            
            if (isSelected) {
                item.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
            }
        });
    }

	hanldleClickItem(event){
		this.term = '';
		this.produtos = undefined;
	}
}