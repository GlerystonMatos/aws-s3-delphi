object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AWS - S3'
  ClientHeight = 620
  ClientWidth = 517
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
    Left = 8
    Top = 136
    Width = 87
    Height = 13
    Caption = 'Storage Endpoint:'
  end
  object btnLoad: TSpeedButton
    Left = 390
    Top = 77
    Width = 121
    Height = 32
    Caption = 'Upload'
    OnClick = btnLoadClick
  end
  object btndownload: TSpeedButton
    Left = 390
    Top = 112
    Width = 121
    Height = 32
    Caption = 'Download'
    OnClick = btndownloadClick
  end
  object btnexcluir: TSpeedButton
    Left = 390
    Top = 147
    Width = 121
    Height = 32
    Caption = 'Excluir'
    OnClick = btnexcluirClick
  end
  object btnbuckets: TSpeedButton
    Left = 390
    Top = 184
    Width = 121
    Height = 32
    Caption = 'Listar Buckets'
    OnClick = btnbucketsClick
  end
  object btnArquivos: TSpeedButton
    Left = 390
    Top = 222
    Width = 121
    Height = 32
    Caption = 'Listar Arquivos'
    OnClick = btnArquivosClick
  end
  object btnBucket: TSpeedButton
    Left = 390
    Top = 41
    Width = 121
    Height = 32
    Caption = 'Criar Bucket'
    OnClick = btnBucketClick
  end
  object lbAccesKey: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 13
    Caption = 'Acces key:'
  end
  object lbSecretKey: TLabel
    Left = 8
    Top = 35
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
    Top = 60
    Width = 36
    Height = 13
    Caption = 'Bucket:'
  end
  object lbFolder: TLabel
    Left = 8
    Top = 85
    Width = 34
    Height = 13
    Caption = 'Folder:'
  end
  object lbFolderList: TLabel
    Left = 8
    Top = 110
    Width = 53
    Height = 13
    Caption = 'Folder List:'
  end
  object lbBuckets: TLabel
    Left = 8
    Top = 158
    Width = 41
    Height = 13
    Caption = 'Buckets:'
  end
  object lbArquivos: TLabel
    Left = 199
    Top = 158
    Width = 46
    Height = 13
    Caption = 'Arquivos:'
  end
  object lstlistabuckts: TListBox
    Left = 8
    Top = 177
    Width = 185
    Height = 436
    ItemHeight = 13
    TabOrder = 4
  end
  object lstListaArquivos: TListBox
    Left = 199
    Top = 177
    Width = 185
    Height = 436
    ItemHeight = 13
    TabOrder = 5
  end
  object edtBucket: TEdit
    Left = 48
    Top = 57
    Width = 336
    Height = 21
    TabOrder = 2
  end
  object edtAccesKey: TEdit
    Left = 64
    Top = 5
    Width = 320
    Height = 21
    TabOrder = 0
    Text = 'SUA CHAVE AQUI'
  end
  object detSecretkey: TEdit
    Left = 67
    Top = 32
    Width = 317
    Height = 21
    TabOrder = 1
    Text = 'SUA SENHA AQUI'
  end
  object detFolder: TEdit
    Left = 48
    Top = 82
    Width = 336
    Height = 21
    TabOrder = 3
  end
  object detFolderList: TEdit
    Left = 65
    Top = 107
    Width = 319
    Height = 21
    TabOrder = 6
  end
  object amcAmazon: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 440
    Top = 329
  end
  object odFile: TOpenDialog
    Left = 440
    Top = 377
  end
end
