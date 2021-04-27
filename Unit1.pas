unit Unit1;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, sChart, System.Generics.Collections;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Edit6: TEdit;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit3Click(Sender: TObject);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit4Click(Sender: TObject);
    procedure Edit5Click(Sender: TObject);
    procedure Edit5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit6Click(Sender: TObject);
    procedure Edit6KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure GroupBox1Exit(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
  private
    ChartSet: tChartSet;
    Chart: tChart;
    Candles: TObjectList<tCandle>;
    CandleLastClose: Extended;
    LineLastClose: array of Extended;
    Lines: array of TList<Extended>;
    procedure CandleGenerate;
    procedure LinesGenerate;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CandleGenerate;
var
  _Candle: tCandle; // in sChart
begin
  _Candle := tCandle.Create;

  _Candle.Open := CandleLastClose + Random(11) - 5;
  _Candle.Close := _Candle.Open + Random(11) - 5;

  if _Candle.Open > _Candle.Close then
  begin
    _Candle.High := _Candle.Open + Random(5);
    _Candle.Low := _Candle.Close - Random(5);
  end
  else
  begin
    _Candle.High := _Candle.Close + Random(5);
    _Candle.Low := _Candle.Open - Random(5);
  end;

  Candles.Add(_Candle);

  CandleLastClose := _Candle.Close;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ChartSet.Box := CheckBox1.Checked;

  PaintBox1.Repaint;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  ChartSet.CandleColor := CheckBox2.Checked;

  PaintBox1.Repaint;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  ChartSet.GradationExtend := CheckBox3.Checked;

  PaintBox1.Repaint;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  ChartSet.HorizontalLine := CheckBox4.Checked;

  PaintBox1.Repaint;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.BackgroundColor := StringToColor(Edit1.Text);

    PaintBox1.Repaint;

    Edit1.SelectAll;
  end;
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  Edit2.SelectAll;
end;

procedure TForm1.Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.Decimal := StrToInt(Edit2.Text);

    PaintBox1.Repaint;

    Edit2.SelectAll;
  end;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
  Edit3.SelectAll;
end;

procedure TForm1.Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.Gradation := StrToInt(Edit3.Text);

    PaintBox1.Repaint;

    Edit3.SelectAll;
  end;
end;

procedure TForm1.Edit4Click(Sender: TObject);
begin
  Edit4.SelectAll;
end;

procedure TForm1.Edit4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.HorizontalLineY := StrToFloat(Edit4.Text);

    PaintBox1.Repaint;

    Edit4.SelectAll;
  end;
end;

procedure TForm1.Edit5Click(Sender: TObject);
begin
  Edit5.SelectAll;
end;

procedure TForm1.Edit5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.LabelWidth := StrToInt(Edit5.Text);

    PaintBox1.Repaint;

    Edit5.SelectAll;
  end;
end;

procedure TForm1.Edit6Click(Sender: TObject);
begin
  Edit6.SelectAll;
end;

procedure TForm1.Edit6KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ChartSet.LineColor := StringToColor(Edit6.Text);

    PaintBox1.Repaint;

    Edit6.SelectAll;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ChartSet := tChartSet.Create;

  ChartSet.BackgroundColor := StringToColor(Edit1.Text);
  ChartSet.Box := CheckBox1.Checked;
  ChartSet.CandleColor := CheckBox2.Checked;
  ChartSet.Decimal := StrToInt(Edit2.Text);
  ChartSet.Gradation := StrToInt(Edit3.Text);
  ChartSet.GradationExtend := CheckBox3.Checked;
  ChartSet.HorizontalLine := CheckBox4.Checked;
  ChartSet.HorizontalLineY := StrToFloat(Edit4.Text);
  ChartSet.LabelWidth := StrToInt(Edit5.Text);
  ChartSet.LineColor := StringToColor(Edit6.Text);
  ChartSet.PaintBox := PaintBox1;

  Chart := tChart.Create(ChartSet);

  Candles := TObjectList<tCandle>.Create;

  SetLength(Lines, 3);
  SetLength(LineLastClose, 3);

  for i := 0 to High(Lines) do
  begin
    Lines[i] := TList<Extended>.Create;
  end;
end;

procedure TForm1.GroupBox1Exit(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.LinesGenerate;
var
  i: Integer;
begin
  for i := 0 to High(Lines) do
  begin
    Lines[i].Add(linelastclose[i] + Random(11) - 5);

    LineLastClose[i] := lines[i].List[lines[i].Count - 1];
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  if RadioButton1.Checked then
  begin
    Chart.CandleDraw(Candles);
  end
  else if RadioButton2.Checked  then
  begin
    Chart.CandleFlow(Candles);
  end
  else if RadioButton3.Checked then
  begin
    Chart.CandleLinesDraw(Candles, lines);
  end
  else if RadioButton4.Checked then
  begin
    Chart.LineDraw(lines[0]);
  end;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  Candles.Clear;

  CandleLastClose := 0;

  Timer1.Enabled := True;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  Candles.Clear;

  CandleLastClose := 0;

  Timer1.Enabled := True;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
var
  i: Integer;
begin
  Candles.Clear;

  CandleLastClose := 0;

  for i := 0 to High(Lines) do
  begin
    Lines[i].Clear;

    LineLastClose[i] := 0;
  end;

  Timer1.Enabled := True;
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  Lines[0].Clear;

  LineLastClose[0] := 0;

  Timer1.Enabled := True;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if RadioButton1.Checked or RadioButton2.Checked then
  begin
    CandleGenerate;
  end
  else if RadioButton3.Checked then
  begin
    CandleGenerate;
    LinesGenerate;
  end
  else if RadioButton4.Checked then
  begin
    LinesGenerate;
  end;

  PaintBox1.Repaint;
end;

end.
