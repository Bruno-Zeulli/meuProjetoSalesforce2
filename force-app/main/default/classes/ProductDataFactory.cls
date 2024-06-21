/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class ProductDataFactory {
  public static Product2 createProduct(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'Vida', Family = 'Prestamista');
    return produto;
  }

  public static Product2 insertProduct(){
    Product2 produto = createProduct();
    insert produto;
    return produto;
  }

  public static Product2 createProductHab(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'Seguro Casa', Family = 'Habitacional');
    return produto;
  }

  public static Product2 insertProductHab(){
    Product2 produto = createProductHab();
    insert produto;
    return produto;
  }

  public static Product2 createProductPres(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'Seguro Vida', Family = 'Prestamista');
    return produto;
  }

  public static Product2 insertProductPres(){
    Product2 produto = createProductPres();
    insert produto;
    return produto;
  }

  public static Product2 createProductAuto(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'Seguro Auto', Family = 'Auto');
    return produto;
  }

  public static Product2 insertProductAuto(){
    Product2 produto = createProductAuto();
    insert produto;
    return produto;
  }

  public static Product2 createProductRCPM(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'RCPM', Family = 'Habitacional');
    return produto;
  }

  public static Product2 insertProductRCPM(){
    Product2 produto = createProductRCPM();
    insert produto;
    return produto;
  }

  public static Product2 createProductAgro(){
    Product2 produto = new Product2(ProductCode = '7705', Name = 'Agro', Family = 'Agro');
    return produto;
  }

  public static Product2 insertProductAgro(){
    Product2 produto = createProductAgro();
    insert produto;
    return produto;
  }
}