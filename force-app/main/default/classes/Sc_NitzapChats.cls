global class Sc_NitzapChats implements Schedulable {
    global void execute(SchedulableContext sc) {
        Batch_NitzapChats batch = new Batch_NitzapChats();
        Database.executeBatch(batch, 100);
    }
}

// sf project deploy start --metadata ApexClass:Sc_NitzapChats --metadata ApexClass:Sc_NitzapChats_Test -l RunSpecifiedTests -t Sc_NitzapChats_Test -o Connection_Salvabras