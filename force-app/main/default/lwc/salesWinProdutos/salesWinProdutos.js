import deleteItens from "@salesforce/apex/SalesWinProdutos.deleteItens";
import getProducts from "@salesforce/apex/SalesWinProdutos.getProducts";
import searchProducts from "@salesforce/apex/SalesWinProdutos.searchProducts";
import { LightningElement, api, track } from "lwc";
import * as helper from 'c/helper';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from "lightning/refresh";


export default class SalesWinProdutos extends LightningElement {
    @api recordId;
    isMobile;
    term = ""; searchTimeout; @track produtos; selectedIndex = -1; 
	loading = false;


	connectedCallback(){
		this.getProducts();

        this.isMobile = /SalesforceMobile/i.test(window.navigator.userAgent);
	}

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

	myProducts;
	async getProducts(){
		this.loading = true;
		const prods = await getProducts({
			recordId: this.recordId,
		});

		this.loading = false;
		if(prods.length === 0) {
			this.myProducts = undefined;
			return;
		}

		prods.forEach(el => {
			el.link = '/' + el.Id;
		});

		this.myProducts = prods;
	}


    async deleteItem(event){

     
        if(this.isMobile){
            const confirm = window.confirm('Deletar esse item?');
            if(!confirm){return;}
        }

        this.loading=true;
        const produto = event.currentTarget.dataset.id;
        const lst = [produto];
        await deleteItens({
            ids: lst
        }).then(el=>{
            this.getProducts();
            this.handleRefreshView();
        })
        .catch(err=>{
            const msg = helper.findMessage(err);
            this.showToast('Erro', msg, 'error');
        });

        this.loading=false;
        
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


    handleRefreshView() {
        this.dispatchEvent(new RefreshEvent());
    }

}