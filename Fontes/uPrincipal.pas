unit uPrincipal;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Cloud.CloudAPI, Vcl.FileCtrl,
  Data.Cloud.AmazonAPI, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, IPPeerClient;

type
  TfrmPrincipal = class(TForm)
    amcAmazon: TAmazonConnectionInfo;
    lbStorageEndpoint: TLabel;
    btnLoad: TSpeedButton;
    btndownload: TSpeedButton;
    btnexcluir: TSpeedButton;
    btnbuckets: TSpeedButton;
    btnArquivos: TSpeedButton;
    lstlistabuckts: TListBox;
    lstListaArquivos: TListBox;
    edtBucket: TEdit;
    btnBucket: TSpeedButton;
    odFile: TOpenDialog;
    lbAccesKey: TLabel;
    edtAccesKey: TEdit;
    lbSecretKey: TLabel;
    detSecretkey: TEdit;
    btnConectar: TSpeedButton;
    lbBucket: TLabel;
    lbFolder: TLabel;
    detFolder: TEdit;
    lbFolderList: TLabel;
    detFolderList: TEdit;
    lbBuckets: TLabel;
    lbArquivos: TLabel;
    procedure btnbucketsClick(Sender: TObject);
    procedure btnArquivosClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btndownloadClick(Sender: TObject);
    procedure btnexcluirClick(Sender: TObject);
    procedure btnBucketClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
  private
    { Private declarations }
    amazonStorageService: TAmazonStorageService;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnBucketClick(Sender: TObject);
begin
  amazonStorageService.CreateBucket(edtBucket.Text, TAmazonACLType.amzbaPrivate, TAmazonRegion.amzrUSWest1, nil);
  MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
end;

procedure TfrmPrincipal.btnArquivosClick(Sender: TObject);
var
  strBuckt: string;
  bucktInfo: TAmazonBucketResult;
  objInfo: TAmazonObjectResult;
begin
  strBuckt := lstlistabuckts.Items[lstlistabuckts.ItemIndex];
  bucktInfo := amazonStorageService.GetBucket(strBuckt, nil);
  lstListaArquivos.Items.Clear;
  for objInfo in bucktInfo.Objects do
  begin
    if (Trim(detFolderList.text) <> '') then
    begin
      if (Pos(Trim(detFolderList.text), objInfo.Name) > 0) then
      begin
        lstListaArquivos.Items.Add(objInfo.Name);
      end;
    end
    else
    begin
      lstListaArquivos.Items.Add(objInfo.Name);
    end;
  end;
end;

procedure TfrmPrincipal.btnbucketsClick(Sender: TObject);
var
  respInfo: TCloudResponseInfo;
  list: TStrings;
  contador: Integer;
begin
  respInfo := TCloudResponseInfo.Create;
  try
    list := amazonStorageService.ListBuckets(respInfo);
    lstlistabuckts.Items.Clear;

    if (Assigned(list)) then
    begin
      for contador := 0 to Pred(list.Count) do
      begin
        lstlistabuckts.Items.Add(list.Names[contador]);
      end;
    end;
  finally
    respInfo.Free;
    list.Free;
  end;
end;

procedure TfrmPrincipal.btndownloadClick(Sender: TObject);
var
  fStream: TStream;
  sDir, sFile: string;
begin
  fStream := TMemoryStream.Create;
  try
    sFile := lstListaArquivos.Items[lstListaArquivos.ItemIndex];
    Screen.Cursor := crHourGlass;
    amazonStorageService.GetObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sFile, fStream);
    fStream.Position := 0;

    sDir := ExtractFilePath(ParamStr(0));

    if selectDirectory('Selecione a pasta', 'C:\', sDir) then
    begin
      if (not DirectoryExists(ExtractFilePath(sDir + PathDelim + StringReplace(sFile, '/', '\', [rfReplaceAll])))) then
        ForceDirectories(ExtractFilePath(sDir + PathDelim + StringReplace(sFile, '/', '\', [rfReplaceAll])));

      TMemoryStream(fStream).SaveToFile(sDir + PathDelim + sFile);
      MessageDlg('Arquivo salvo com sucesso.', mtInformation, [mbOK], 0);
    end;

  finally
    fStream.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPrincipal.btnexcluirClick(Sender: TObject);
var
  sfile: string;
begin
  sfile := lstListaArquivos.Items[lstListaArquivos.ItemIndex];
  if (MessageDlg('Deseja realmente excluir este arquivo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    try
      try
        Screen.Cursor := crHourGlass;
        amazonStorageService.DeleteObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sfile);
        MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
      finally
        Screen.Cursor := crDefault;
      end;
    except
      MessageDlg('Erro ao excluir o arquivo.', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmPrincipal.btnLoadClick(Sender: TObject);
var
  sFile: string;
  fContents: TBytes;
  fReader: TBinaryReader;
  sMeta: TStringList;
begin
  if (odFile.Execute) then
  begin
    sFile := ExtractFileName(odFile.FileName);
    fReader := TBinaryReader.Create(odFile.FileName);

    if (Trim(detFolder.Text) <> '') then
      sFile := Trim(detFolder.Text) + sFile;

    try
      fContents := fReader.ReadBytes(fReader.BaseStream.Size);
    finally
      fReader.Free;
    end;

    try
      try
        sMeta := TStringList.Create;
        sMeta.Add('Content-type=*.jpg');
        Screen.Cursor := crHourGlass;
        try
          amazonStorageService.UploadObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sFile, fContents, False, sMeta);
          MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
        except
          on e: Exception do
          begin
            ShowMessage(e.Message);
          end;
        end;
      finally
        Screen.Cursor := crDefault;
        sMeta.Free;
      end;
    except
      on e: exception do
      begin
        Screen.Cursor := crDefault;
        MessageDlg('Erro ao executar o upload.', mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnConectarClick(Sender: TObject);
begin
  amcAmazon.AccountName := Trim(edtAccesKey.Text);
  amcAmazon.AccountKey := Trim(detSecretkey.Text);

  amazonStorageService := TAmazonStorageService.Create(amcAmazon);
  lbStorageEndpoint.Caption := 'Storage Endpoint: ' + amcAmazon.StorageEndpoint;
  MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
end;

end.
