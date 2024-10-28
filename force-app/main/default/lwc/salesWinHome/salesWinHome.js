import { LightningElement, api } from "lwc";
import newOppModal from "c/salesWinNewOpp";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SalesWinHome extends LightningElement {

    @api recordId;


    handleClickNew(){

        newOppModal.open({
            size: "small",
            recordId: this.recordId
        }).then(async (result) => {
            if (result?.ok) {
              this.showToast("Sucesso", "Registro gravado com sucesso!", "success");
            }
          });

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


}