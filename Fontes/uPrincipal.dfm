object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AWS - S3'
  ClientHeight = 365
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbStorageEndpoint: TLabel
    Left = 390
    Top = 117
    Width = 87
    Height = 13
    Caption = 'Storage Endpoint:'
  end
  object btnUpload: TSpeedButton
    Left = 517
    Top = 5
    Width = 121
    Height = 32
    Caption = 'Upload'
    OnClick = btnUploadClick
  end
  object btnDownload: TSpeedButton
    Left = 517
    Top = 41
    Width = 121
    Height = 32
    Caption = 'Download'
    OnClick = btnDownloadClick
  end
  object btnExcluir: TSpeedButton
    Left = 517
    Top = 79
    Width = 121
    Height = 32
    Caption = 'Excluir'
    OnClick = btnExcluirClick
  end
  object btnListarBuckets: TSpeedButton
    Left = 390
    Top = 79
    Width = 121
    Height = 32
    Caption = 'Listar Buckets'
    OnClick = btnListarBucketsClick
  end
  object btnListarArquivos: TSpeedButton
    Left = 643
    Top = 5
    Width = 121
    Height = 32
    Caption = 'Listar Arquivos'
    OnClick = btnListarArquivosClick
  end
  object btnCriarBucket: TSpeedButton
    Left = 390
    Top = 41
    Width = 121
    Height = 32
    Caption = 'Criar Bucket'
    OnClick = btnCriarBucketClick
  end
  object lbAccesKey: TLabel
    Left = 8
    Top = 11
    Width = 52
    Height = 13
    Caption = 'Acces key:'
  end
  object lbSecretKey: TLabel
    Left = 8
    Top = 38
    Width = 56
    Height = 13
    Caption = 'Secret Key:'
  end
  object btnConectar: TSpeedButton
    Left = 390
    Top = 5
    Width = 121
    Height = 32
    Caption = 'Conectar'
    OnClick = btnConectarClick
  end
  object lbBucket: TLabel
    Left = 8
    Top = 63
    Width = 36
    Height = 13
    Caption = 'Bucket:'
  end
  object lbFolder: TLabel
    Left = 8
    Top = 88
    Width = 34
    Height = 13
    Caption = 'Folder:'
  end
  object lbFolderList: TLabel
    Left = 8
    Top = 113
    Width = 53
    Height = 13
    Caption = 'Folder List:'
  end
  object lbBuckets: TLabel
    Left = 8
    Top = 140
    Width = 41
    Height = 13
    Caption = 'Buckets:'
  end
  object lbArquivos: TLabel
    Left = 388
    Top = 140
    Width = 46
    Height = 13
    Caption = 'Arquivos:'
  end
  object lstListaBuckets: TListBox
    Left = 8
    Top = 159
    Width = 375
    Height = 200
    ItemHeight = 13
    TabOrder = 4
  end
  object lstListaArquivos: TListBox
    Left = 388
    Top = 159
    Width = 375
    Height = 200
    ItemHeight = 13
    TabOrder = 5
  end
  object detBucket: TEdit
    Left = 48
    Top = 60
    Width = 336
    Height = 21
    TabOrder = 2
    Text = 'NOME DO BUCKET PARA SER CRIADO'
  end
  object detAccesKey: TEdit
    Left = 64
    Top = 8
    Width = 320
    Height = 21
    TabOrder = 0
    Text = 'SUA CHAVE AQUI'
  end
  object detSecretkey: TEdit
    Left = 67
    Top = 35
    Width = 317
    Height = 21
    TabOrder = 1
    Text = 'SUA SENHA AQUI'
  end
  object detFolder: TEdit
    Left = 48
    Top = 85
    Width = 336
    Height = 21
    TabOrder = 3
    Text = 'PASTA PARA ARMAZENAR OS ARQUIVOS ENVIADOS'
  end
  object detFolderList: TEdit
    Left = 65
    Top = 110
    Width = 319
    Height = 21
    TabOrder = 6
    Text = 'NOME DA PASTA PARA FILTRAR A CONSULTA'
  end
  object amcAmazon: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    UseDefaultEndpoints = False
    Left = 664
    Top = 49
  end
  object odFile: TOpenDialog
    Left = 720
    Top = 49
  end
end
