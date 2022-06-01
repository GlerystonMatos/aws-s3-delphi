unit uPrincipal;

interface

uses
  Winapi.Windows, Vcl.FileCtrl, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Cloud.CloudAPI, StrUtils,
  Data.Cloud.AmazonAPI, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, IPPeerClient,
  System.UITypes;

type
  TfrmPrincipal = class(TForm)
    amcAmazon: TAmazonConnectionInfo;
    lbStorageEndpoint: TLabel;
    btnUpload: TSpeedButton;
    btnDownload: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnListarBuckets: TSpeedButton;
    btnListarArquivos: TSpeedButton;
    lstListaBuckets: TListBox;
    lstListaArquivos: TListBox;
    detBucket: TEdit;
    btnCriarBucket: TSpeedButton;
    odFile: TOpenDialog;
    lbAccesKey: TLabel;
    detAccesKey: TEdit;
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
    procedure btnConectarClick(Sender: TObject);
    procedure btnCriarBucketClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnListarBucketsClick(Sender: TObject);
    procedure btnListarArquivosClick(Sender: TObject);
  private
    FAmazonStorageService: TAmazonStorageService;
    procedure LoadMetaData(var metaData: TStringList);
    procedure LoadHeaders(var headers: TStringList);
    procedure MensagemSucesso;
    procedure MensagemErro;
    function GetObjectName: string;
    function GetBytesFile: TBytes;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.MensagemSucesso;
begin
  MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
end;

procedure TfrmPrincipal.MensagemErro;
begin
  MessageDlg('Erro ao executar a operação.', mtError, [mbOK], 0);
end;

procedure TfrmPrincipal.btnConectarClick(Sender: TObject);
begin
  amcAmazon.AccountName := Trim(detAccesKey.Text);
  amcAmazon.AccountKey := Trim(detSecretkey.Text);

  FAmazonStorageService := TAmazonStorageService.Create(amcAmazon);

  lbStorageEndpoint.Caption := 'Storage Endpoint: ' + amcAmazon.StorageEndpoint;
  MensagemSucesso;
end;

procedure TfrmPrincipal.btnCriarBucketClick(Sender: TObject);
begin
  FAmazonStorageService.CreateBucket(detBucket.Text, TAmazonACLType.amzbaPrivate, amzrUSEast1, nil);
  MensagemSucesso;
end;

procedure TfrmPrincipal.btnUploadClick(Sender: TObject);
var
  content: TBytes;
  bucketName: string;
  objectName: string;
  acl: TAmazonACLType;
  headers: TStringList;
  metaData: TStringList;
  reducedRedundancy: Boolean;
begin
  if (odFile.Execute) then
  begin
    try
      objectName := GetObjectName;
      content := GetBytesFile;
      try
        metaData := TStringList.Create;
        try
          LoadMetaData(metaData);
          headers := TStringList.Create;
          try
            LoadHeaders(headers);
            try
              acl := amzbaPublicRead;
              reducedRedundancy := False;
              Screen.Cursor := crHourGlass;
              bucketName := lstListaBuckets.Items[lstListaBuckets.ItemIndex];

              FAmazonStorageService.UploadObject(bucketName, objectName, content, reducedRedundancy, metaData, headers, acl);
              MensagemSucesso;
            except
              on e: Exception do
                ShowMessage(e.Message);
            end;
          finally
            headers.Free;
          end;
        finally
          metaData.Free;
        end;
      except
        on e: Exception do
          MensagemErro;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TfrmPrincipal.GetObjectName: string;
var
  objectName: string;
begin
  objectName := ExtractFileName(odFile.FileName);

  if (Trim(detFolder.Text) <> '') then
    objectName := Trim(detFolder.Text) + objectName;
  Result := objectName;
end;

function TfrmPrincipal.GetBytesFile: TBytes;
var
  reader: TBinaryReader;
begin
  reader := TBinaryReader.Create(odFile.FileName);
  try
    Result := reader.ReadBytes(reader.BaseStream.Size);
  finally
    reader.Free;
  end;
end;

procedure TfrmPrincipal.LoadMetaData(var metaData: TStringList);
begin
  metaData.Add('File-Name=' + ExtractFileName(odFile.FileName));
end;

procedure TfrmPrincipal.LoadHeaders(var headers: TStringList);
const
  fileTipe: Array of String = ['.jpg','.png','.pdf','.xml','.zip'];
begin
  case (AnsiIndexStr(ExtractFileExt(odFile.FileName), fileTipe)) of
    0 : headers.Add('Content-Type=image/jpeg');
    1 : headers.Add('Content-Type=image/png');
    2 : headers.Add('Content-Type=application/pdf');
    3 : headers.Add('Content-Type=application/xml');
    4 : headers.Add('Content-Type=application/zip');
  end;
end;

procedure TfrmPrincipal.btnDownloadClick(Sender: TObject);
var
  stream: TStream;
  FileName: string;
  directory: string;
begin
  stream := TMemoryStream.Create;
  try
    Screen.Cursor := crHourGlass;
    FileName := lstListaArquivos.Items[lstListaArquivos.ItemIndex];
    FAmazonStorageService.GetObject(lstListaBuckets.Items[lstListaBuckets.ItemIndex], FileName, stream);
    stream.Position := 0;

    directory := ExtractFilePath(ParamStr(0));
    if (selectDirectory('Selecione a pasta', 'C:\', directory)) then
    begin
      if (not DirectoryExists(ExtractFilePath(directory + PathDelim + StringReplace(FileName, '/', '\',
        [rfReplaceAll])))) then
        ForceDirectories(ExtractFilePath(directory + PathDelim + StringReplace(FileName, '/', '\', [rfReplaceAll])));

      TMemoryStream(stream).SaveToFile(directory + PathDelim + FileName);
      MensagemSucesso;
    end;
  finally
    stream.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
  FileName: string;
begin
  FileName := lstListaArquivos.Items[lstListaArquivos.ItemIndex];
  if (MessageDlg('Deseja realmente excluir este arquivo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    try
      try
        Screen.Cursor := crHourGlass;
        FAmazonStorageService.DeleteObject(lstListaBuckets.Items[lstListaBuckets.ItemIndex], FileName);
        MensagemSucesso;
      finally
        Screen.Cursor := crDefault;
      end;
    except
      MensagemErro;
    end;
  end;
end;

procedure TfrmPrincipal.btnListarBucketsClick(Sender: TObject);
var
  list: TStrings;
  contador: Integer;
  respInfo: TCloudResponseInfo;
begin
  respInfo := TCloudResponseInfo.Create;
  try
    list := FAmazonStorageService.ListBuckets(respInfo);
    try
      lstListaBuckets.Items.Clear;
      if (Assigned(list)) then
      begin
        for contador := 0 to Pred(list.Count) do
          lstListaBuckets.Items.Add(list.Names[contador]);
      end;
    finally
      list.Free;
    end;
  finally
    respInfo.Free;
  end;
end;

procedure TfrmPrincipal.btnListarArquivosClick(Sender: TObject);
var
  strBuckt: string;
  objInfo: TAmazonObjectResult;
  bucktInfo: TAmazonBucketResult;
begin
  strBuckt := lstListaBuckets.Items[lstListaBuckets.ItemIndex];
  bucktInfo := FAmazonStorageService.GetBucket(strBuckt, nil);

  lstListaArquivos.Items.Clear;
  for objInfo in bucktInfo.Objects do
  begin
    if (Trim(detFolderList.Text) <> '') then
    begin
      if (Pos(Trim(detFolderList.Text), objInfo.Name) > 0) then
        lstListaArquivos.Items.Add(objInfo.Name);
    end
    else
      lstListaArquivos.Items.Add(objInfo.Name);
  end;
end;

end.
