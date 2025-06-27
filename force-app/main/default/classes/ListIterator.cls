/**
    Helps with iterating a collection of records using a batch size
    Example Usage:
        List<String> dataSet = new String[]{'1', '2', '3', '4', '5', '6', '7'};

        ListIterator it = new ListIterator(dataSet, 2);
        while (it.hasNext()) {  //This loop will run 4 times
        }   

        Output:
        1,2
        3,4
        5,6
        7

    @author Shah Kadirmohideen
*/
public with sharing class ListIterator {
    private List<Object> records;
    private Integer size;
    private Integer lastProcessedIndex;
    private Integer currentBatchNumber;
    private Integer totalBatches;

    public ListIterator(List<Object> records, Integer size) {
        this.records = records;
        this.size = size;
        this.lastProcessedIndex = -1;
        this.currentBatchNumber = 0;
        if (records != null) {
            this.totalBatches = records.size() / size;
            if (Math.mod(records.size(), size) > 0) {
                this.totalBatches++;
            }
        }
    }

    public Boolean hasNext() {
        if (records == null) return false;
        if (this.lastProcessedIndex + 1 < records.size()) {
            return true;
        }
        return false;
    }

    public List<Object> next() {
        if (records == null) {
            return null;
        }

        List<Object> subList = new List<Object>();
        Integer counter = 1;
        Integer lindex = lastProcessedIndex;
        Integer nextPosition = lindex + 1;
        while (true) {
            subList.add(records.get(nextPosition++));
            lastProcessedIndex++;
            counter++;
            if (counter > size || lastProcessedIndex + 1 == records.size()) {
                break;
            }
        }
        currentBatchNumber++;
        return subList;
    }

}