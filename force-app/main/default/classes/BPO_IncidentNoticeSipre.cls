/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   Windson Santos                       Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

public class BPO_IncidentNoticeSipre {
  public String protocoloSF { get; set; }
  public EstruturaSegurado segurado { get; set; }
  public EstruturaReclamante reclamante { get; set; }
  public EstruturaEndereco endereco { get; set; }
  public List<EstruturaContrato> contratos { get; set; }
  public String tipoDemanda { get; set; }
  public String flag { get; set; }
  public String dataComunicado { get; set; }
  public String dataSinistro { get; set; }
  public Integer tipoSinistro { get; set; }
  public String historicoSinistro { get; set; }

  public class EstruturaContrato {
    public String apolice { get; set; }
    public String certificado { get; set; }
    public String status { get; set; }
    public String inicioVigencia { get; set; }
    public String fimVigencia { get; set; }
    public String valorSegurado { get; set; }
    public String tipoBeneficiario { get; set; }
    public String perceitualPagoBeneficiario { get; set; }
  }

  public class EstruturaSegurado {
    public String cpfcnpj { get; set; }
    public String dataNascimento { get; set; }
    public String nome { get; set; }
    public Integer sexo { get; set; }
    public Integer tipoInclusao { get; set; }
    public String usuario { get; set; }
  }

  public class EstruturaReclamante {
    public String celular { get; set; }
    public String cpf { get; set; }
    public String email { get; set; }
    public String email1 { get; set; }
    public String nome { get; set; }
    public String nomeAgente { get; set; }
    public Integer parentesco { get; set; }
    public String telResidencial { get; set; }
    public String telComercial { get; set; }
  }

  public class EstruturaEndereco {
    public String descricao { get; set; }
    public String bairro { get; set; }
    public String cidade { get; set; }
    public String uf { get; set; }
    public String cep { get; set; }
  }
}