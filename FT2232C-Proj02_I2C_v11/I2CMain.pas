unit I2CMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, D2xxunit, DSI2C, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Label2: TLabel;
    UpDown1: TUpDown;
    Edit2: TEdit;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    ComboBox2: TComboBox;
    Label4: TLabel;
    procedure ComboBox1DropDown(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  Names = Array[1..20] of string;
  Names_Ptr = ^Names;

var
  Form1: TForm1;
  My_Names : Names;

  BinFileName : TfileName;
  BinFile: file;
  ImageData : ARRAY[0..127] of word;
  DevAddress :integer;

implementation

{$R *.DFM}


procedure GetNames;
Var i : integer;
begin
for i := 1 to 20 do My_Names[i] := '';
Form1.ComboBox1.Clear;
List_Devs(@My_Names);
i := 1;
if (My_Names[i] <> '' ) then
  begin
    repeat
    Form1.ComboBox1.Items.Add(My_Names[i]);
    i := i + 1;
    until (My_Names[i] = '');
  end;
end;


procedure TForm1.ComboBox1DropDown(Sender: TObject);
begin
GetNames;
end;


function Check_For_Dev_A(Name : string) : boolean;
var len,i : integer;
SubString : string;
begin
Check_For_Dev_A := false;
if (Name <> '') then
  begin
  len := length(Name);
  if (len > 2) then
    begin
    SubString := Name[len-1] + Name[len];
    if (SubString = ' A') then Check_For_Dev_A := true;
    end;
  end;
end;

procedure Read_24C02(DName : String);
var passed : boolean;
i,j : integer;
begin
DevAddress := strtoint(Form1.ComboBox2.Text);
form1.Memo1.Clear;
passed := Init_Controller(DName);
if passed then
  begin
  for j := 0 to $7F do
    begin
    i := Read_Location(j,DevAddress);
    i := i AND $FFFF;
    imageData[j] := i;
    form1.Memo1.Lines.Add('Addr : ' + HexWrdToStr(j)+' Data : ' + HexWrdToStr(i) );
    end;
  ClosePort;
  end;

end;

procedure Program_To_Address;
var passed : boolean;
i,j : integer;
DName : string;
begin
DevAddress := strtoint(Form1.ComboBox2.Text);
DName := form1.ComboBox1.Text;
passed := Check_For_Dev_A(DName);
if passed then
  begin
  passed := Init_Controller(DName);
  if passed then
    begin
    for j := 0 to $7F do
      begin
      passed := Write_Location(j,DevAddress,j);
      form1.Memo1.Lines.Add('Addr : ' + HexWrdToStr(j)+' Data : ' + HexWrdToStr(j) );
      end;
    ClosePort;
    end;
  end
else
  begin
  form1.Memo1.Lines.Add('You must select the "A" port of the chip to use the MPSSE');
  end;
end;

procedure Prog_From_File;
var passed : boolean;
i,j : integer;
DName : string;
begin
DevAddress := strtoint(Form1.ComboBox2.Text);
DName := form1.ComboBox1.Text;
passed := Check_For_Dev_A(DName);
if passed then
  begin
  passed := Init_Controller(DName);
  if passed then
    begin
    for j := 0 to $7F do
      begin
      passed := Write_Location(j,DevAddress,imageData[j]);
      form1.Memo1.Lines.Add('Addr : ' + HexWrdToStr(j)+' Data : ' + HexWrdToStr(j) );
      end;
    ClosePort;
    end;
  end
else
  begin
  form1.Memo1.Lines.Add('You must select the "A" port of the chip to use the MPSSE');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var passed : boolean;
DName,tst : string;
begin
dsi2c.speed := strtoint(form1.Edit2.Text);
DName := form1.ComboBox1.Text;
passed := Check_For_Dev_A(DName);
if passed then
  begin
  Read_24C02(DName);
  end
else
  begin
  form1.Memo1.Lines.Add('You must select the "A" port of the chip to use the MPSSE');
  end;
end;

procedure update_clk_divisor;
begin
form1.Edit2.Text := inttostr(form1.UpDown1.Position);
dsi2c.speed := strtoint(form1.Edit2.Text);
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
update_clk_divisor;
end;

procedure TForm1.Button3Click(Sender: TObject);
var passed : boolean;
DName : string;
begin
DevAddress := strtoint(Form1.ComboBox2.Text);
dsi2c.speed := strtoint(form1.Edit2.Text);
DName := form1.ComboBox1.Text;
passed := Check_For_Dev_A(DName);
if passed then
  begin
  passed := Erase_24C02(DName,DevAddress);
  if passed then
    form1.Memo1.Lines.Add('Erase - Success')
  else
    form1.Memo1.Lines.Add('Erase - Failed');
  end
else
  begin
  form1.Memo1.Lines.Add('You must select the "A" port of the chip to use the MPSSE');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Program_To_Address;
end;

procedure Read_In_Array;
var cnt : integer;
ByteData : ARRAY[0..255] of byte;
begin
Form1.OpenDialog1.FileName := '';
Form1.OpenDialog1.execute;
if Form1.OpenDialog1.FileName <> '' then
  begin
    form1.Edit1.Text := Form1.OpenDialog1.FileName;
    try
    BinFileName := Form1.OpenDialog1.FileName;
    AssignFile(BinFile,BinFileName);
    reset(BinFile,1);
    blockread(BinFile,ByteData,256,Cnt);
    CloseFile(BinFile);
    finally
    end;
  for cnt := 0 to 127 do
    ImageData[cnt] := (ByteData[(Cnt * 2) + 1] * 256 ) OR (ByteData[Cnt * 2]);
  end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
Read_In_Array;
end;

procedure TForm1.N1Click(Sender: TObject);
var Cnt : integer;
ByteData : ARRAY[0..255] of byte;
begin
for cnt := 0 to 127 do
  begin
  ByteData[(Cnt * 2)] := ImageData[cnt] AND $FF;
  ByteData[(Cnt * 2) + 1] := ImageData[cnt] DIV 256;
  end;
Form1.SaveDialog1.FileName := '';
Form1.SaveDialog1.Execute;
if Form1.SaveDialog1.FileName <> '' then
  begin
    form1.Edit1.Text := Form1.SaveDialog1.FileName;
    try
    BinFileName := Form1.SaveDialog1.FileName;
    AssignFile(BinFile,BinFileName);
    rewrite(BinFile,1);
    blockwrite(BinFile,ByteData,256,Cnt);
    CloseFile(BinFile);
    finally
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Read_In_Array;
Prog_From_File;
end;

procedure TForm1.UpDown1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
update_clk_divisor;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
form1.UpDown1.Position := 60;
update_clk_divisor;
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
if (form1.Edit2.Text <> '') then
  begin
  form1.UpDown1.Position := strtoint(form1.edit2.Text );
  update_clk_divisor;
  end;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
if (form1.Edit2.Text <> '') then
  begin
  form1.UpDown1.Position := strtoint(form1.edit2.Text );
  update_clk_divisor;
  end;
end;

end.
