/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class sdgLabelsTest {
    //Instantiate teh sdgLabels object
    @isTest
    static void getLabels()
  {
      List<String> labels = new List<String>();
      labels = sdgLabels.strings;
      System.assert(labels.size()>0,'');
  }
}