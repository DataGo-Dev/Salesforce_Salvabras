import deleteItens from "@salesforce/apex/SalesWinProdutos.deleteItens";
import getProducts from "@salesforce/apex/SalesWinProdutos.getProducts";
import searchProducts from "@salesforce/apex/SalesWinProdutos.searchProducts";
import { LightningElement, api, track } from "lwc";
import * as helper from 'c/helper';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from "lightning/refresh";
import ProdutoModal from "c/salesWinProdutoModal";

export default class SalesWinProdutos extends LightningElement {
    @api recordId;
    isMobile;
    term = ""; searchTimeout; @track entrys; selectedIndex = -1; 
	loading = false;


	connectedCallback(){
		this.getProducts();

        this.isMobile = /SalesforceMobile/i.test(window.navigator.userAgent);
	}

    handleInputChange(event) {
		this.entrys = undefined;

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
			this.entrys = undefined;
			return;
		}
		
		this.entrys = prods;
    }

	handleKeyDown(event) {

        const { key } = event;

        if (key === 'ArrowDown') {
            event.preventDefault(); 
            if (this.selectedIndex < this.entrys.length - 1) {
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
			   const selectedItem = this.entrys[this.selectedIndex];
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

        const id = event.currentTarget.dataset.id;
        const myEntry = this.entrys.find(x => x.Id === id);

        const record = {
            'Product2Id': myEntry.Product2Id,
            'ListPrice': myEntry.UnitPrice,
            'TipoOperacao__c' : "",
            'Quantity': 1,
            'UnitPrice': myEntry.UnitPrice,
            'Discount':  0.0,
            'PricebookEntryId': myEntry.Id,
            'Discount': 0.0,
            'QuoteId': this.recordId
        };

        ProdutoModal.open({
            size: 'medium',
            record: record,
            product2id:  myEntry.Product2Id
        }).then(el=>{
            
            if(el?.ok){
                this.showToast('Sucesso', 'Item adicionado com sucesso!', 'success');
                this.getProducts();
            }

        });


        this.term = '';
		this.entrys = undefined;
	}

    handleEdit(event){
        const id = event.currentTarget.dataset.id;
        const product2id = event.currentTarget.dataset.productid;
        console.log(id);
        
        ProdutoModal.open({
            size: 'medium',
            recordId: id,
            product2id: product2id
        }).then(el=>{
            
            if(el?.ok){
                this.getProducts();
            }

        });
        
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