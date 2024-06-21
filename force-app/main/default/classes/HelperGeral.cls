/*****************************************************************
Nome:  HelperGeral
Data de criação: 24/05/2018
============================================================
Propósito: Classe helper geral
============================================================
Histórico de alterações
-------
VERSÃO      AUTOR               DATA                Descrição
1.0.0       Lucas Shimabuko     24/05/2018          Criação de método que calcula dígito verificador.
*****************************************************************/

public class HelperGeral {
  public static Map<String, Object> digitoModulo11(Long intNumero){
    List<Integer> lstPesos = new List<Integer>{ 2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5, 6, 7, 8, 9 };
    Map<String, Object> retorno = new Map<String, Object>();
    System.debug('Número de entrada: ' + intNumero);
    Integer soma = 0;
    Integer idx = 0;

    if(intNumero == 0 || String.valueOf(intNumero).Length() > 16){
      retorno.put('Success', false);
      retorno.put('Mensagem', 'Número não suportado.');
    }

    String strNumero = String.valueOf(intNumero);

    for(Integer intPos = strNumero.Length() - 1; intPos >= 0; intPos--){
      soma += Integer.valueOf(strNumero.mid(intPos, 1)) * lstPesos[idx];
      idx++;
    }

    Integer resto = math.mod((soma * 10), 11);
    Integer digitoVerificador = resto;

    if(digitoVerificador >= 10){
      digitoVerificador = 0;
    }

    retorno.put('Success', true);
    retorno.put('Digito', digitoVerificador);
    System.debug('Dígito calculado: ' + digitoVerificador);
    return retorno;
  }
}