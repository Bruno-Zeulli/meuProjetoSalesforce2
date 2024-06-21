public with sharing class B2U_BuscarApoliceController {
  @AuraEnabled(cacheable=true)
  public static List<Order> getApolice(String searchParam, String value, String company){
    /**
         *   <option value="NUMAPO">Número da Apólice</option>
                <option value="BULK">Bulk</option>
                <option value="NUMPEDIDO">Número do Pedido</option>
         */
    System.debug('PARAMETRO :::' + searchParam + ', VALUE:::' + value + ' , Company:::' + company);

    String parametro = '';

    if(searchParam.equals('BOOK')){
      parametro = 'PoNumber';
    }else if(searchParam.equals('BOOKSEMFORMATACAO') && company != ''){
      System.debug('Entrei no BOOK sem formatacao ==>');
      Order order = new Order();
      order.Company__c = company;
      order.PoNumber = value;
      order = Corporate_OrderBO.verifyCompanyAndPONumber(order);
      System.debug('Order ==>' + order);
      value = order.PoNumber;
      parametro = 'PoNumber';
    }else if(searchParam.equals('NUMPEDIDO')){
      parametro = 'OrderNumber';
    }

    String query = 'SELECT Id FROM ORDER WHERE ' + parametro + ' = \'' + value + '\'';
    List<Order> orderList = (List<Order>) Database.query(query);
    return orderList;
  }

  @AuraEnabled
  public static List<String> getCompanies(){
    List<String> options = new List<String>();
    Schema.DescribeFieldResult fieldResult = Order.Company__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for(Schema.PicklistEntry f : ple){
      options.add(f.getValue());
    }
    return options;
  }
}