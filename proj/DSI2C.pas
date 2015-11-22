unit DSI2C;

//====================================================
//==
//== This block is used to talk to the FT2232C chip.
//==
//== AD0 - SCL         out
//== AD1 - SDA         out
//== AD2 - SDA         in
//== AD3 -
//== AD4 - WP          out
//== AD5 - GPIOL1
//== AD6 - GPIOL2
//== AD7 - GPIOL3
//==
//====================================================

interface

Uses Windows,D2XXUNIT;

Type
  Names = Array[1..20] of string;
  Names_Ptr = ^Names;
  DataBuff = Array[0..63] of byte;
  Data_Ptr = ^DataBuff;


// Exported Functions

function HexWrdToStr(Dval : integer) : string;

function HexByteToStr(Dval : integer) : string;

function Read_Location(LocAddress,DevAddress : integer) : integer;

function Write_Location(LocAddress,DevAddress,Data : integer) : boolean;

function Erase_24C02(DName : String;DevAddress : integer) : Boolean;

function Init_Controller(DName : String) : boolean;

procedure ClosePort;


procedure List_Devs( My_Names_Ptr : Names_Ptr);

Var
  Saved_Handle: DWord;
  PortAIsOpen : boolean;
  OutIndex : integer;
  PageData : Array[0..511] of Byte;
  speed : integer;
  Out_Buff : DataBuff;
  In_Buff : DataBuff;
  Saved_Port_Value : byte;

  //  RBFFileName : TfileName;

const USBBuffSize : integer = $4000;


implementation


function HexWrdToStr(Dval : integer) : string;
var i : integer;
retstr : string;
begin
retstr := '';
i := (Dval AND $F000) DIV $1000;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
i := (Dval AND $F00) DIV $100;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
i := (Dval AND $F0) DIV $10;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
i := Dval AND $F;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
HexWrdToStr := retstr;
end;

function HexByteToStr(Dval : integer) : string;
var i : integer;
retstr : string;
begin
retstr := '';
i := (Dval AND $F0) DIV $10;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
i := Dval AND $F;
case i of
  0 : retstr := retstr + '0';
  1 : retstr := retstr + '1';
  2 : retstr := retstr + '2';
  3 : retstr := retstr + '3';
  4 : retstr := retstr + '4';
  5 : retstr := retstr + '5';
  6 : retstr := retstr + '6';
  7 : retstr := retstr + '7';
  8 : retstr := retstr + '8';
  9 : retstr := retstr + '9';
  10 : retstr := retstr + 'A';
  11 : retstr := retstr + 'B';
  12 : retstr := retstr + 'C';
  13 : retstr := retstr + 'D';
  14 : retstr := retstr + 'E';
  15 : retstr := retstr + 'F';
end;
HexByteToStr := retstr;
end;

function OpenPort(PortName : string) : boolean;
Var res : FT_Result;
NoOfDevs,i,J : integer;
Name : String;
DualName : string;
done : boolean;
begin
PortAIsOpen := False;
OpenPort := False;
Name := '';
Dualname := PortName;
res := GetFTDeviceCount;
if res <> Ft_OK then exit;
NoOfDevs := FT_Device_Count;
j := 0;
if NoOfDevs > 0 then
  begin
    repeat
      repeat
      res := GetFTDeviceDescription(J);
      if (res <> Ft_OK) then  J := J + 1;
      until (res = Ft_OK) OR (J=NoOfDevs);
    if res <> Ft_OK then exit;
    done := false;
    i := 1;
    Name := '';
      repeat
      if ORD(FT_Device_String_Buffer[i]) <> 0 then
        begin
        Name := Name + FT_Device_String_Buffer[i];
        end
      else
        begin
        done := true;
        end;
      i := i + 1;
      until done;
    J := J + 1;
    until (J = NoOfDevs) or (name = DualName);
  end;

if (name = DualName) then
  begin
  res := Open_USB_Device_By_Device_Description(name);
  if res <> Ft_OK then exit;
  OpenPort := true;
  res := Get_USB_Device_QueueStatus;
  if res <> Ft_OK then exit;
  PortAIsOpen := true;
  end
else
  begin
  OpenPort := false;
  end;

end;


procedure List_Devs( My_Names_Ptr : Names_Ptr);
Var res : FT_Result;
NoOfDevs,i,J,k : integer;
Name : String;
done : boolean;
begin
PortAIsOpen := False;
Name := '';
res := GetFTDeviceCount;
if res <> Ft_OK then exit;
NoOfDevs := FT_Device_Count;
j := 0;
k := 1;
if NoOfDevs > 0 then
  begin
    repeat
    res := GetFTDeviceDescription(J);
    if res = Ft_OK then
      begin
      done := false;
      i := 1;
      Name := '';
        repeat
        if ORD(FT_Device_String_Buffer[i]) <> 0 then
          begin
          Name := Name + FT_Device_String_Buffer[i];
          end
        else
          begin
          done := true;
          My_Names_Ptr[k]:= Name;
          k := k + 1;
          end;
        i := i + 1;
        until done;
      end;
    J := J + 1;
    until (J = NoOfDevs);
  end;

end;


procedure ClosePort;
Var res : FT_Result;
begin
if PortAIsOpen then
  res := Close_USB_Device;
PortAIsOpen := False;
end;


procedure SendBytes(NumberOfBytes : integer);
var i : integer;
begin
i := Write_USB_Device_Buffer( NumberOfBytes);
OutIndex := OutIndex - i;
end;


procedure AddToBuffer(I:integer);
begin
FT_Out_Buffer[OutIndex]:= I AND $FF;
inc(OutIndex);
end;


procedure Read_Data(Rin_buff : data_ptr;BitCount : word);
//
// This will work out the number of whole bytes to read
//
var res : FT_Result;
NoBytes,i,j : integer;
BitShift,Mod_BitCount : integer;
Last_Bit : byte;
Temp_Buffer : array[0..64000] of byte;
TotalBytes : integer;
begin
i := 0;
Mod_BitCount := BitCount - 1; // adjust for bit count of 1 less than no of bits
NoBytes := Mod_BitCount DIV 8;  // get whole bytes
BitShift := Mod_BitCount MOD 8; // get remaining bits
if BitShift > 0 then NoBytes := NoBytes + 1; // bump whole bytes if bits left over
i := 0;
TotalBytes := 0;
repeat
  repeat
    res := Get_USB_Device_QueueStatus;
  until FT_Q_Bytes > 0;
  j := Read_USB_Device_Buffer(FT_Q_Bytes);
  for i := 0 to (j-1) do
    begin
    Temp_Buffer[TotalBytes] := FT_In_Buffer[i];
    TotalBytes := TotalBytes + 1;
    end;
until TotalBytes >= NoBytes;

for j := 0 to (NoBytes) do
  begin
  Rin_buff[j] := Temp_Buffer[j];
  end;
end;



function Sync_To_MPSSE : boolean;
//
// This should satisfy outstanding commands.
//
// We will use $AA and $AB as commands which
// are invalid so that the MPSSE block should echo these
// back to us preceded with an $FA
//
var res : FT_Result;
i,j : integer;
Done : boolean;
begin
Sync_To_MPSSE := false;
res := Get_USB_Device_QueueStatus;
if res <> FT_OK then exit;
if (FT_Q_Bytes > 0) then
  i := Read_USB_Device_Buffer(FT_Q_Bytes);
  repeat
  OutIndex := 0;
  AddToBuffer($AA); // bad command
  SendBytes(OutIndex);
  res := Get_USB_Device_QueueStatus;
  until (FT_Q_Bytes > 0) or (res <> FT_OK); // or timeout
if res <> FT_OK then exit;
i := Read_USB_Device_Buffer(FT_Q_Bytes);
j := 0;
Done := False;
  repeat
  if (FT_In_Buffer[j] = $FA) then
    begin
    if (j < (i-2)) then
      begin
      if (FT_In_Buffer[j+1] = $AA) then Done := true;
      end;
    end;
  j := j + 1;
  until (j=i) or Done;
OutIndex := 0;
AddToBuffer($AB); // bad command
SendBytes(OutIndex);
  repeat
  res := Get_USB_Device_QueueStatus;
  until (FT_Q_Bytes > 0) or (res <> FT_OK); // or timeout
if res <> FT_OK then exit;
i := Read_USB_Device_Buffer(FT_Q_Bytes);
j := 0;
Done := False;
  repeat
  if (FT_In_Buffer[j] = $FA) then
    begin
    if (j <= (i-2)) then
      begin
      if (FT_In_Buffer[j+1] = $AB) then Done := true;
      end;
    end;
  j := j + 1;
  until (j=i) or Done;

if Done then Sync_To_MPSSE := true;
end;

//================================================
//== I2C routines
//================================================

function Set_Start : boolean;
begin
Set_Start := false;
if PortAIsOpen then
  begin
  Saved_Port_Value := Saved_Port_Value OR $03; //SCL SDA high
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  Saved_Port_Value := Saved_Port_Value AND $FD; //SCL high SDA low
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  Saved_Port_Value := Saved_Port_Value AND $FC; //SCL low SDA low
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  Set_Start := true;
  end;
end;

function Set_Stop : boolean;
begin
Set_Stop := false;
if PortAIsOpen then
  begin
  Saved_Port_Value := Saved_Port_Value OR $01; //SCL high SDA low
  Saved_Port_Value := Saved_Port_Value AND $FD; //SCL high SDA low
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  Saved_Port_Value := Saved_Port_Value OR $02; //SCL high SDA high
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  // tristate SDA SCL
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($10); // set SCL,SDA as input,WP as out
  Set_Stop := true;
  end;
end;


function ScanIn_Out(BitCount : integer;OutBuffPtr : Data_Ptr ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanIn_Out := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount div 8 > 0 then
    begin // do whole bytes
    i := (Mod_BitCount div 8) - 1;
    AddToBuffer($35); // clk data bytes out on -ve in -ve clk MSB
    AddToBuffer(i AND $FF);
    AddToBuffer((i DIV 256) AND $FF);
    // now add the data bytes to go out
      repeat
      AddToBuffer(OutBuffPtr[j]);
      j := j + 1;
      until j > i;
    end;
  if Mod_BitCount mod 8 > 0 then
    begin // do remaining bits
    i := (Mod_BitCount mod 8);
    AddToBuffer($37); // clk data bits out on -ve in -ve clk MSB
    AddToBuffer(i AND $FF);
    // now add the data bits to go out
    AddToBuffer(OutBuffPtr[j]);
    end;
  end;
end;

function ScanIn(BitCount : integer ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanIn := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount = 0 then
    begin
    AddToBuffer($27); // clk data bits in -ve clk MSB
    AddToBuffer(0);
    end
  else
    begin
    if Mod_BitCount div 8 > 0 then
      begin // do whole bytes
      i := (Mod_BitCount div 8) - 1;
      AddToBuffer($25); // clk data bytes in -ve clk MSB
      AddToBuffer(i AND $FF);
      AddToBuffer((i DIV 256) AND $FF);
      end;
    if Mod_BitCount mod 8 > 0 then
      begin // do remaining bits
      i := (Mod_BitCount mod 8);
      AddToBuffer($27); // clk data bits in -ve clk MSB
      AddToBuffer(i AND $FF);
      end;
    end;
  end;
end;

function ScanOut(BitCount : integer;OutBuffPtr : Data_Ptr ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanOut := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount div 8 > 0 then
    begin // do whole bytes
    i := (Mod_BitCount div 8) - 1;
    AddToBuffer($11); // clk data bytes out on -ve MSB
    AddToBuffer(i AND $FF);
    AddToBuffer((i DIV 256) AND $FF);
    // now add the data bytes to go out
      repeat
      AddToBuffer(OutBuffPtr[j]);
      j := j + 1;
      until j > i;
    end;
  if Mod_BitCount mod 8 > 0 then
    begin // do remaining bits
    i := (Mod_BitCount mod 8);
    AddToBuffer($13); // clk data bits out on -ve MSB
    AddToBuffer(i AND $FF);
    // now add the data bits to go out
    AddToBuffer(OutBuffPtr[j]);
    end;
  end;
end;

function Send_Byte_Then_Chk_ACK(Data : byte) : boolean;
var SDA,passed : boolean;
i : integer;
begin
Send_Byte_Then_Chk_ACK := false;
Out_Buff[0] := Data;
passed := ScanOut(8,@Out_Buff);
AddToBuffer($80);
AddToBuffer(Saved_Port_Value);
AddToBuffer($11); // set SCL,WP as out SDA as in
passed := ScanIn(1);
AddToBuffer($87);  //Send immediate
SendBytes(OutIndex); // send off the command
Read_Data(@In_Buff,1);
i := In_Buff[0] AND $01;
if (i = 0 ) then
  Send_Byte_Then_Chk_ACK := true;
AddToBuffer($80);
AddToBuffer(Saved_Port_Value);
AddToBuffer($13); // set SCL,SDA,WP as out
end;

function Send_Byte_Then_Ignore_ACK(Data : byte) : boolean;
var SDA,passed : boolean;
begin
Send_Byte_Then_Ignore_ACK := true;
Out_Buff[0] := Data;
passed := ScanOut(8,@Out_Buff);
if passed then
  begin
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($11); // set SCL,WP as out SDA as in
  Out_Buff[0] := 0;
  passed := ScanOut(1,@Out_Buff);
  AddToBuffer($80);
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($13); // set SCL,SDA,WP as out
  end;
end;


function Read_Byte_Then_Chk_ACK(var Data : byte) : boolean;
var SDA,passed : boolean;
i : integer;
begin
Read_Byte_Then_Chk_ACK := false;
AddToBuffer($80);
AddToBuffer(Saved_Port_Value);
AddToBuffer($11); // set SCL,WP as out SDA as in
passed := ScanIn(9);
AddToBuffer($87);  //Send immediate
SendBytes(OutIndex); // send off the command
Read_Data(@In_Buff,9);
Data := In_Buff[0];
i := In_Buff[1] AND $01;
if (i = 0 ) then
  Read_Byte_Then_Chk_ACK := true;
AddToBuffer($80);
AddToBuffer(Saved_Port_Value);
AddToBuffer($13); // set SCL,SDA,WP as out
end;

function Init_Controller(DName : String) : boolean;
var passed : boolean;
res : FT_Result;
begin
Init_Controller := false;
passed := OpenPort(DName);
if passed then
  begin
  res := Set_USB_Device_LatencyTimer(16);
  res := Set_USB_Device_BitMode($00,$00); // reset controller
  res := Set_USB_Device_BitMode($00,$02); // enable JTAG controller
  passed := Sync_To_MPSSE;
  end;
if passed then
  begin
  OutIndex := 0;
//  sleep(20); // wait for all the USB stuff to complete
  AddToBuffer($80); // set SK,DO,CS as out
  AddToBuffer($13); // SDA SCL WP high
  Saved_Port_Value := $13;
  AddToBuffer($13); // inputs on GPIO12-14
  AddToBuffer($82); // outputs on GPIO21-24
  AddToBuffer($0F);
  AddToBuffer($0F);
  AddToBuffer($86); // set clk divisor
  AddToBuffer(speed AND $FF);
  AddToBuffer(speed SHR 8);
  // turn off loop back
  AddToBuffer($85);
  SendBytes(OutIndex); // send off the command
  Init_Controller := true;
  end;
end;


function Read_Location(LocAddress,DevAddress : integer) : integer;
var passed,ACK : boolean;
i : integer;
Data : byte;
begin
Read_Location := 0;
OutIndex := 0;
passed := Set_Start;
// set up read address
i := $A0;
i := i or ((DevAddress shl 1) AND $E);
ACK := Send_Byte_Then_Chk_ACK(i);
ACK := Send_Byte_Then_Chk_ACK(LocAddress);
passed := Set_Start;
// now read data
i := $A1;
i := i or ((DevAddress shl 1) AND $E);
ACK := Send_Byte_Then_Chk_ACK(i);
Data := 0;
ACK := Read_Byte_Then_Chk_ACK(Data);

passed := Set_Stop;
SendBytes(OutIndex); // send off the command
Read_Location := Data;

end;


function Write_Location(LocAddress,DevAddress,data : integer) : boolean;
var passed,ACK : boolean;
i : integer;
dbyte : byte;
begin
Write_Location := false;
OutIndex := 0;
Saved_Port_Value := Saved_Port_Value AND $EF; //WP low
repeat
passed := Set_Start;
// set up device address
i := $A0;
i := i or ((DevAddress shl 1) AND $E);
ACK := Send_Byte_Then_Chk_ACK(i);
until ACK;
// set up byte address
ACK := Send_Byte_Then_Chk_ACK(LocAddress);
// now write data
dbyte := data AND $FF;
ACK := Send_Byte_Then_Chk_ACK(dbyte);
passed := Set_Stop;
SendBytes(OutIndex); // send off the command
Saved_Port_Value := Saved_Port_Value OR $10; //WP high

repeat
passed := Set_Start;
// set up write address
i := $A0;
i := i or ((DevAddress shl 1) AND $E);
ACK := Send_Byte_Then_Chk_ACK(i);
until ACK;

Write_Location := true;
end;


function Erase_24C02(DName : String;DevAddress : integer) : Boolean;
var passed : boolean;
address,i : integer;
begin
Erase_24C02 := false;
passed := Init_Controller(DName);
if passed then
  begin
  for i := 0 to $7f do
    begin
    passed := Write_Location(i,DevAddress,$FF);
    end;
  ClosePort;
  Erase_24C02 := true;
  end;
end;


end.
