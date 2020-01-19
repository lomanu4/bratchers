unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, REST.Types, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.TMSLiveGridDataBinding, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, FireDAC.Comp.BatchMove.DataSet,
  FireDAC.Comp.BatchMove, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, Data.DB, FireDAC.Comp.DataSet, FMX.TMSBaseControl,
  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
  FMX.TMSLiveGrid, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FMX.Controls.Presentation, FMX.StdCtrls,
  FireDAC.Comp.BatchMove.SQL, FireDAC.Stan.StorageJSON, FireDAC.Comp.UI,
  System.JSON,
  FMX.Bind.Grid, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Data.Bind.Controls,
  FMX.Layouts, Fmx.Bind.Navigator;

type
  TForm1 = class(TForm)
    TMSFMXLiveGrid1: TTMSFMXLiveGrid;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    BindSourceDB2: TBindSourceDB;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Button1: TButton;
    FDBatchMove1: TFDBatchMove;
    FDMemTable1id: TWideStringField;
    FDMemTable1Materiale: TWideStringField;
    FDMemTable1Descripzione: TWideStringField;
    FDMemTable1Quantita: TWideStringField;
    FDMemTable1Treno: TWideStringField;
    FDMemTable1Discorta: TWideStringField;
    FDMemTable1Commento: TWideStringField;
    FDMemTable1Data: TWideStringField;
    FDMemTable1Creatoda: TWideStringField;
    FDMemTable1Ordinato: TWideStringField;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    FDBatchMoveSQLWriter1: TFDBatchMoveSQLWriter;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Button2: TButton;
    Button3: TButton;
    StringGrid1: TStringGrid;
    BindSourceDB5: TBindSourceDB;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable1ID: TFDAutoIncField;
    FDTable1MATERIALE: TWideMemoField;
    FDTable1DESCRIPZIONE: TWideMemoField;
    FDTable1QUANTITA: TWideMemoField;
    FDTable1TRENO: TBlobField;
    FDTable1DISCORTA: TWideMemoField;
    FDTable1COMMENTO: TWideMemoField;
    FDTable1DATA: TWideMemoField;
    FDTable1CREATODA: TWideMemoField;
    FDTable1ORDINATO: TWideMemoField;
    BindSourceDB6: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB6: TLinkGridToDataSource;
    AniIndicator1: TAniIndicator;
    Button4: TButton;
    BindSourceDB3: TBindSourceDB;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 type
  TTupdate = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;
   Update:TTupdate;
implementation
     //
{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Copy server db to local db
  FDConnection1.Connected := False;
  FDTable1.Close;
  FDBatchMoveSQLWriter1.Connection:=FDConnection1;
  FDBatchMoveSQLWriter1.TableName:='Richiesta';
  FDBatchMoveDataSetReader1.DataSet:=FDMemTable1;
  RESTRequest1.Execute;
  FDBatchMove1.Execute;
 FDConnection1.Connected := True;
 FDTable1.Active:=True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

//  FDConnection1.Connected := True;
//  FDQuery1.Active := False;
//  FDQuery1.Active := True;
//  FDQuery1.SQL.Clear;
//  FDQuery1.SQL.Add('Select * From RICHIESTA');
//  FDQuery1.Open();
//  FDTable1.Active := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  aggiornarichiesta: TJSONObject;
  i: Integer;
begin




   FDTable1.First;
  for i := 0 to FDTable1.RecordCount do
  begin

    aggiornarichiesta := TJSONObject.Create;
    aggiornarichiesta.AddPair('id', FDTable1ID.Text);
    aggiornarichiesta.AddPair('Materiale', FDTable1.FieldByName('Materiale')
      .AsString);
    aggiornarichiesta.AddPair('Descripzione',
      FDTable1.FieldByName('Descripzione').AsString);
    aggiornarichiesta.AddPair('Quantita', FDTable1.FieldByName('Quantita')
      .AsString);
    aggiornarichiesta.AddPair('Treno', FDTable1.FieldByName('Treno').AsString);
    aggiornarichiesta.AddPair('Discorta', FDTable1.FieldByName('Discorta')
      .AsString);
    aggiornarichiesta.AddPair('Commento', FDTable1.FieldByName('Commento')
      .AsString);
    aggiornarichiesta.AddPair('Creatoda', FDTable1.FieldByName('Creatoda')
      .AsString);
    aggiornarichiesta.AddPair('Ordinato', FDTable1.FieldByName('Ordinato')
      .AsString);

    RESTClient1.BaseURL := 'http://localhost/loman/Product/update.php';
    RESTRequest1.ClearBody;
    RESTRequest1.AddBody(aggiornarichiesta.ToString,
      ContentTypeFromString('application/json'));
    RESTRequest1.Execute;
    FDTable1.Next ;
     AniIndicator1.Visible:=True;
    AniIndicator1.Enabled:=True;

    end;

 end;








procedure TForm1.Button4Click(Sender: TObject);
begin
  AniIndicator1.Visible:=true;
  AniIndicator1.Enabled:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//FDTable1.First;
end;

{ TThread }

procedure TTupdate.Execute;
  var
  aggiornarichiesta: TJSONObject;
  i: Integer;
begin
  inherited;

begin
  // Update:=TTupdate.Create(false);
  for i := 0 to form1.FDTable1.RecordCount do
  begin
    aggiornarichiesta := TJSONObject.Create;
    aggiornarichiesta.AddPair('id',form1. FDTable1ID.Text);
    aggiornarichiesta.AddPair('Materiale',form1. FDTable1.FieldByName('Materiale')
      .AsString);
    aggiornarichiesta.AddPair('Descripzione',
     form1. FDTable1.FieldByName('Descripzione').AsString);
    aggiornarichiesta.AddPair('Quantita', form1.FDTable1.FieldByName('Quantita')
      .AsString);
    aggiornarichiesta.AddPair('Treno',form1. FDTable1.FieldByName('Treno').AsString);
    aggiornarichiesta.AddPair('Discorta', form1.FDTable1.FieldByName('Discorta')
      .AsString);
    aggiornarichiesta.AddPair('Commento',form1. FDTable1.FieldByName('Commento')
      .AsString);
    aggiornarichiesta.AddPair('Creatoda',form1. FDTable1.FieldByName('Creatoda')
      .AsString);
    aggiornarichiesta.AddPair('Ordinato',form1. FDTable1.FieldByName('Ordinato')
      .AsString);

   form1. RESTClient1.BaseURL := 'http://localhost/loman/Product/update.php';
   form1. RESTRequest1.ClearBody;
   form1. RESTRequest1.AddBody(aggiornarichiesta.ToString,
      ContentTypeFromString('application/json'));
   form1. RESTRequest1.Execute;
   form1. FDTable1.Next ;
   form1. AniIndicator1.Visible:=True;
   form1. AniIndicator1.Enabled:=True;
    end;




end;
end;

end.
