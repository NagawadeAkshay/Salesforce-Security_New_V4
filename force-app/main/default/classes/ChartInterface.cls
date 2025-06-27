global interface ChartInterface {
    Map<String,Object> constructChart(String filterClause); /* This method returns the JSON required to construct charts.*/
}                                                           /* Filter clause replaces placeholder value in query */