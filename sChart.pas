unit sChart;

interface

uses ExtCtrls, SysUtils, Graphics, Forms, Windows, System.Classes, System.Generics.Collections, Vcl.StdCtrls, System.Types, System.UITypes, System.Math;

type
  tCandle = class
    Close: Extended;
    High: Extended;
    Low: Extended;
    Open: Extended;
  end;

  tTrade = class // not for general use
    Entry: Extended;
    High: Extended;
    Low: Extended;
    PrepPosition: Integer;
  end;

  tChartSet = class
    BackgroundColor: Integer;
    Box: Boolean; // should be drawn only once in the same PaintBox
    CandleColor: Boolean;
    Decimal: Integer;
    Gradation: Extended;
    GradationExtend: Boolean;
    HorizontalLine: Boolean; // can be used as a base line with HorizontalLineY
    HorizontalLineY: Extended;
    LabelWidth: Integer;
    LineColor: Integer; // e.g. clRed
    PaintBox: TPaintBox;
    Trades: TList<tTrade>;
  end;

  tChart = class
  private
    X: Integer;
    Height, Width: Integer;
    SeriesMaxValue, SeriesMinValue: Extended;
    Multiplier: Extended;
    Range: Extended;
    XWidth: Extended;
    ChartSet: tChartSet;
    Points: array of TPoint;
    ColorList: TList<Integer>;
    CandleLines: Boolean;
    LastCandleColor: Integer;
    Epsilon3: Extended;
    procedure Gradation;
    procedure ChartInitialize;
    procedure HorizontalLineDraw(_Canvas: TCanvas; _Y: Integer; _Horizon: Boolean);
    procedure TradeLineDraw(_Y, _Color: Integer);
    procedure MultiplierCalculate;
  public
    procedure CandleDraw(_Candles: TList<tCandle>);
    procedure LineDraw(_Extendeds: TList<Extended>); overload;
    procedure LineDraw(_Integers: TList<Integer>); overload;
    procedure LinesDraw(var _Lines: array of TList<Extended>);
    procedure CandleLinesDraw(_Candles: TList<tCandle>; var _Lines: array of TList<Extended>);
    procedure CandleFlow(_Candles: TList<tCandle>);
    constructor Create(_ChartSet: tChartSet);
  end;

implementation

{ ChartClass }

procedure tChart.CandleDraw(_Candles: TList<tCandle>);
var
  _Y1, _Y2: Integer;
  i: Integer;
begin
  ChartInitialize;

  if _Candles.Count > 0 then
  begin
    if not CandleLines then
    begin
      SeriesMaxValue := _Candles.List[0].High;
      SeriesMinValue := _Candles.List[0].Low;

      for i := 0 to _Candles.Count - 1 do
      begin
        if _Candles.List[i].High > SeriesMaxValue + Epsilon3 then
        begin
          SeriesMaxValue := _Candles.List[i].High;
        end;

        if _Candles.List[i].Low < SeriesMinValue - Epsilon3 then
        begin
          SeriesMinValue := _Candles.List[i].Low;
        end;
      end;
    end;

    MultiplierCalculate;

    Gradation;

    if _Candles.Count = 1 then
    begin
      XWidth := 0;
    end
    else
    begin
      XWidth := Width / (_Candles.Count - 1);
    end;

    for i := 0 to _Candles.Count - 1 do
    begin
      if _Candles.Count = 1 then
      begin
        X := Round(Width / 2) + 5;
      end
      else
      begin
        X := Round(i * XWidth) + 5;
      end;

      if ChartSet.CandleColor then
      begin
        if _Candles.List[i].Close > _Candles.List[i].Open + Epsilon3 then
        begin
          ChartSet.PaintBox.Canvas.Pen.Color := clRed;
        end
        else if _Candles.List[i].Close < _Candles.List[i].Open - Epsilon3 then
        begin
          ChartSet.PaintBox.Canvas.Pen.Color := clBlue;
        end
        else
        begin
          if i = 0 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clRed;
          end
          else if _Candles.List[i].Close > _Candles.List[i - 1].Close + Epsilon3 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clRed;
          end
          else if _Candles.List[i].Close < _Candles.List[i - 1].Close - Epsilon3 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clBlue;
          end
          else
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := LastCandleColor;
          end;
        end;
      end
      else
      begin
        ChartSet.PaintBox.Canvas.Pen.Color := clBlack;
      end;

      ChartSet.PaintBox.Canvas.Brush.Color := ChartSet.PaintBox.Canvas.Pen.Color;

      LastCandleColor := ChartSet.PaintBox.Canvas.Pen.Color;

      ChartSet.PaintBox.Canvas.MoveTo(X + 1, Round((SeriesMaxValue - _Candles.List[i].High) * Multiplier) + 5); // vertical penetration
      ChartSet.PaintBox.Canvas.LineTo(X + 1, Round((SeriesMaxValue - _Candles.List[i].Low ) * Multiplier) + 5);

      _Y1 := Round((SeriesMaxValue - _Candles.List[i].Open) * Multiplier) + 5;
      _Y2 := Round((SeriesMaxValue - _Candles.List[i].Close) * Multiplier) + 5;

      if Abs(_Candles.List[i].Open - _Candles.List[i].Close) < Epsilon3 then
      begin
        if Range = 0 then // draws in vertical center height
        begin
          ChartSet.PaintBox.Canvas.MoveTo(X, Round(Height / 2) + 5);
          ChartSet.PaintBox.Canvas.LineTo(X + 3, Round(Height / 2) + 5);
        end
        else
        begin
          ChartSet.PaintBox.Canvas.MoveTo(X, _Y1);
          ChartSet.PaintBox.Canvas.LineTo(X + 3, _Y2);
        end;
      end
      else
      begin
        ChartSet.PaintBox.Canvas.Rectangle(X, _Y1, X + 3, _Y2);
      end;
    end;
  end;
end;

procedure tChart.LineDraw(_Extendeds: TList<Extended>);
var
  i: Integer;
begin
  ChartInitialize;

  if _Extendeds.Count > 1 then
  begin
    SeriesMaxValue := _Extendeds[0];
    SeriesMinValue := _Extendeds[0];

    for i := 0 to _Extendeds.Count - 1 do
    begin
      if _Extendeds.List[i] > SeriesMaxValue + Epsilon3 then
      begin
        SeriesMaxValue := _Extendeds.List[i];
      end
      else if _Extendeds.List[i] < SeriesMinValue - Epsilon3 then
      begin
        SeriesMinValue := _Extendeds.List[i];
      end;
    end;

    MultiplierCalculate;

    Gradation;

    XWidth := Width / (_Extendeds.Count - 1);

    SetLength(Points, _Extendeds.Count);

    ChartSet.PaintBox.Canvas.Pen.Color := ChartSet.LineColor;

    for i := 0 to _Extendeds.Count - 1 do
    begin
      Points[i] := Point(Round((i) * XWidth) + 5, Round((SeriesMaxValue - _Extendeds.List[i]) * Multiplier) + 5);
    end;

    ChartSet.PaintBox.Canvas.Polyline(Points);
  end;
end;

procedure tChart.CandleFlow(_Candles: TList<tCandle>); // increasing candle amount
var
  _Y1, _Y2: Integer;
  _CandleAmount: Integer;
  _StartIndex: Integer;
  _TradeY: Integer;
  i: Integer;
begin
  ChartInitialize;

  if _Candles.Count > 0 then
  begin
    _CandleAmount := (Width + 7) div 5; // should be modified with space

    _StartIndex := 0;

    if _Candles.Count > _CandleAmount then
    begin
      _StartIndex := _Candles.Count - _CandleAmount;
    end;

    {$REGION 'RANGE CALCULATE'}

    SeriesMaxValue := _Candles.List[_StartIndex].High;
    SeriesMinValue := _Candles.List[_StartIndex].Low;

    for i := _StartIndex to _Candles.Count - 1 do
    begin
      if _Candles.List[i].High > SeriesMaxValue + Epsilon3 then
      begin
        SeriesMaxValue := _Candles.List[i].High;
      end;

      if _Candles.List[i].Low < SeriesMinValue - Epsilon3 then
      begin
        SeriesMinValue := _Candles.List[i].Low;
      end;
    end;

    {$ENDREGION}

    MultiplierCalculate;

    Gradation;

    if ChartSet.Trades <> nil then
    begin
      for i := 0 to ChartSet.Trades.Count - 1 do
      begin
        _TradeY := Round((SeriesMaxValue - ChartSet.Trades.List[i].Entry) * Multiplier) + 5;

        TradeLineDraw(_TradeY, clBlack);
      end;
    end;

    if _StartIndex = 0 then
    begin
      if _Candles.Count = 1 then
      begin
        XWidth := 0;
      end
      else
      begin
        XWidth := Width / (_Candles.Count - 1);
      end;
    end
    else
    begin
      X := -1;
    end;

    for i := _StartIndex to _Candles.Count - 1 do
    begin
      if _StartIndex = 0 then
      begin
        if _Candles.Count = 1 then
        begin
          X := Round(Width / 2) + 5;
        end
        else
        begin
          X := Round(i * XWidth) + 5;
        end;
      end
      else
      begin
        X := X + 5;
      end;

      if ChartSet.CandleColor then
      begin
        if _Candles.List[i].Close > _Candles.List[i].Open + Epsilon3 then
        begin
          ChartSet.PaintBox.Canvas.Pen.Color := clRed;
        end
        else if _Candles.List[i].Close < _Candles.List[i].Open - Epsilon3 then
        begin
          ChartSet.PaintBox.Canvas.Pen.Color := clBlue;
        end
        else
        begin
          if i = 0 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clRed;
          end
          else if _Candles.List[i].Close > _Candles.List[i - 1].Close + Epsilon3 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clRed;
          end
          else if _Candles.List[i].Close < _Candles.List[i - 1].Close - Epsilon3 then
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := clBlue;
          end
          else
          begin
            ChartSet.PaintBox.Canvas.Pen.Color := LastCandleColor;
          end;
        end;
      end
      else
      begin
        ChartSet.PaintBox.Canvas.Pen.Color := clBlack;
      end;

      ChartSet.PaintBox.Canvas.Brush.Color := ChartSet.PaintBox.Canvas.Pen.Color;

      LastCandleColor := ChartSet.PaintBox.Canvas.Pen.Color;

      ChartSet.PaintBox.Canvas.MoveTo(X + 1, Round((SeriesMaxValue - _Candles.List[i].High) * Multiplier) + 5); // vertical penetration
      ChartSet.PaintBox.Canvas.LineTo(X + 1, Round((SeriesMaxValue - _Candles.List[i].Low) * Multiplier) + 5);

      _Y1 := Round((SeriesMaxValue - _Candles.List[i].Open) * Multiplier) + 5;
      _Y2 := Round((SeriesMaxValue - _Candles.List[i].Close) * Multiplier) + 5;

      if Abs(_Candles.List[i].Open - _Candles.List[i].Close) < Epsilon3 then
      begin
        if Range = 0 then // draws in vertical center height
        begin
          ChartSet.PaintBox.Canvas.MoveTo(X, Round(Height / 2) + 5);
          ChartSet.PaintBox.Canvas.LineTo(X + 3, Round(Height / 2) + 5);
        end
        else
        begin
          ChartSet.PaintBox.Canvas.MoveTo(X, _Y1);
          ChartSet.PaintBox.Canvas.LineTo(X + 3, _Y2);
        end;
      end
      else
      begin
        ChartSet.PaintBox.Canvas.Rectangle(X, _Y1, X + 3, _Y2);
      end;
    end;
  end;
end;

procedure tChart.CandleLinesDraw(_Candles: TList<tCandle>; var _Lines: array of TList<Extended>);
var
  i, j: Integer;
begin
  if _Candles.Count > 0 then
  begin
    CandleLines := True;

    SeriesMaxValue := _Candles.List[0].High;
    SeriesMinValue := _Candles.List[0].Low;

    for i := 0 to _Candles.Count - 1 do
    begin
      if _Candles.List[i].High > SeriesMaxValue + Epsilon3 then
      begin
        SeriesMaxValue := _Candles.List[i].High;
      end;

      if _Candles.List[i].Low < SeriesMinValue - Epsilon3 then
      begin
        SeriesMinValue := _Candles.List[i].Low;
      end;
    end;

    for i := 0 to High(_Lines) do
    begin
      for j := 0 to _Lines[i].Count - 1 do
      begin
        if _Lines[i].List[j] > SeriesMaxValue + Epsilon3 then
        begin
          SeriesMaxValue := _Lines[i].List[j];
        end
        else if _Lines[i].List[j] < SeriesMinValue - Epsilon3 then
        begin
          SeriesMinValue := _Lines[i].List[j];
        end;
      end;
    end;

    CandleDraw(_Candles);
    LinesDraw(_Lines);

    CandleLines := False;
  end;
end;

procedure tChart.ChartInitialize;
begin
  Width := ChartSet.PaintBox.Width - ChartSet.LabelWidth - 13;
  Height := ChartSet.PaintBox.Height - 10;

  if ChartSet.Box then // not include label
  begin
    ChartSet.PaintBox.Canvas.Brush.Color := ChartSet.BackgroundColor;
    ChartSet.PaintBox.Canvas.Pen.Color := clBlack;

    ChartSet.PaintBox.Canvas.Rectangle(0, 0, Width + 13, Height + 10);
  end;
end;

constructor tChart.Create(_ChartSet: tChartSet);
begin
  ChartSet := _ChartSet;

  Epsilon3 := 1 / Power(10, ChartSet.Decimal + 1) * 5;

  ColorList := TList<Integer>.Create;

  ColorList.Add(clRed); // you may add more
  ColorList.Add(clBlue);
  ColorList.Add(clBlack);
  ColorList.Add(clGreen);
  ColorList.Add(clLime);
end;

procedure tChart.Gradation;
var
  _Max, _Min: Integer;
  _Gradation, _GradationMinor, _GradiationX: Integer;
  _Y: Integer;
  _iExtended: Extended;
  _Mod: Integer;
  i: Integer;
begin
  if ChartSet.Gradation > 0 then
  begin
    ChartSet.PaintBox.Canvas.Pen.Color := clBlack;

    _Max := Round(Power10(SeriesMaxValue, ChartSet.Decimal)); // extended -> integer
    _Min := Round(Power10(SeriesMinValue, ChartSet.Decimal));
    _Gradation := Round(Power10(ChartSet.Gradation, ChartSet.Decimal));
    _GradationMinor := Round(_Gradation / 5);
    _GradiationX := ChartSet.PaintBox.Width - ChartSet.LabelWidth;

    if _Max > _Min then
    begin
      for i := _Min to _Max do
      begin
        _Mod := i mod _Gradation;

        if (_Mod = 0) or (i mod _GradationMinor = 0) then
        begin
          _iExtended := i / Power10(1, ChartSet.Decimal);

          _Y := Round((SeriesMaxValue - _iExtended) * Multiplier) + 5;

          ChartSet.PaintBox.Canvas.Pen.Color := clBlack;

          if _Mod = 0 then
          begin
            ChartSet.PaintBox.Canvas.MoveTo(_GradiationX, _Y);
            ChartSet.PaintBox.Canvas.LineTo(_GradiationX + 5, _Y);

            SetTextAlign(ChartSet.PaintBox.Canvas.Handle, TA_RIGHT);

            ChartSet.PaintBox.Canvas.TextOut(ChartSet.PaintBox.Width - 5, _Y - 7, Format('%.*n', [ChartSet.Decimal, _iextended]));

            if ChartSet.GradationExtend then
            begin
              HorizontalLineDraw(ChartSet.PaintBox.Canvas, _Y, False);
            end;
          end
          else
          begin
            ChartSet.PaintBox.Canvas.MoveTo(_GradiationX, _Y);
            ChartSet.PaintBox.Canvas.LineTo(_GradiationX + 3, _Y);
          end;
        end;
      end;

      if ChartSet.HorizontalLine then
      begin
        _Y := Round((SeriesMaxValue - ChartSet.HorizontalLineY) * Multiplier) + 5;

        HorizontalLineDraw(ChartSet.PaintBox.Canvas, _Y, True);
      end;
    end;
  end;
end;

procedure tChart.HorizontalLineDraw(_Canvas: TCanvas; _Y: Integer; _Horizon: Boolean);
begin
  if _Horizon then
  begin
    _Canvas.Pen.Color := clSilver;
  end
  else
  begin
    _Canvas.Pen.Color := clBtnFace;
  end;

  _Canvas.MoveTo(5, _Y);
  _Canvas.LineTo(Width + 10, _Y);
end;

procedure tChart.LineDraw(_Integers: TList<Integer>);
var
  i: Integer;
begin
  ChartInitialize;

  if _Integers.Count > 1 then
  begin
    SeriesMaxValue := _Integers[0];
    SeriesMinValue := _Integers[0];

    for i := 0 to _Integers.Count - 1 do
    begin
      if _Integers.List[i] > SeriesMaxValue then
      begin
        SeriesMaxValue := _Integers.List[i];
      end
      else if _Integers.List[i] < SeriesMinValue then
      begin
        SeriesMinValue := _Integers.List[i];
      end;
    end;

    MultiplierCalculate;

    Gradation;

    XWidth := Width / (_Integers.Count - 1);

    SetLength(Points, _Integers.Count);

    ChartSet.PaintBox.Canvas.Pen.Color := ChartSet.LineColor;

    for i := 0 to _Integers.Count - 1 do
    begin
      Points[i] := Point(Round((i) * XWidth) + 5, Round((SeriesMaxValue - _Integers.List[i]) * Multiplier) + 5);
    end;

    ChartSet.PaintBox.Canvas.Polyline(Points);
  end;
end;

procedure tChart.LinesDraw(var _Lines: array of TList<Extended>);
var
  i, j: Integer;
begin
  if not CandleLines then
  begin
    ChartInitialize;
  end;

  if _Lines[0].Count > 1 then
  begin
    if not CandleLines then
    begin
      SeriesMaxValue := _Lines[0].List[0];
      SeriesMinValue := _Lines[0].List[0];

      for i := 0 to High(_Lines) do
      begin
        for j := 0 to _Lines[i].Count - 1 do
        begin
          if _Lines[i].List[j] > SeriesMaxValue + Epsilon3 then
          begin
            SeriesMaxValue := _Lines[i].List[j];
          end
          else if _Lines[i].List[j] < SeriesMinValue - Epsilon3 then
          begin
            SeriesMinValue := _Lines[i].List[j];
          end;
        end;
      end;
    end;

    MultiplierCalculate;

    if not CandleLines then
    begin
      Gradation;
    end;

    XWidth := Width / (_Lines[0].Count - 1);

    SetLength(Points, _Lines[0].Count);

    for i := 0 to High(_Lines) do
    begin
      for j := 0 to _Lines[i].Count - 1 do
      begin
        Points[j] := Point(Round(j * XWidth) + 5, Round((SeriesMaxValue - _Lines[i].List[j]) * Multiplier) + 5);

        ChartSet.PaintBox.Canvas.Pen.Color := ColorList.List[i];
      end;

      ChartSet.PaintBox.Canvas.Polyline(Points);
    end;
  end;
end;

procedure tChart.MultiplierCalculate;
begin
  Range := SeriesMaxValue - SeriesMinValue;

  if Abs(Range - 0) < Epsilon3 then
  begin
    Multiplier := 0;
  end
  else
  begin
    Multiplier := Height / Range;
  end;
end;

procedure tChart.TradeLineDraw(_Y, _Color: Integer);
begin
  ChartSet.PaintBox.Canvas.Pen.Color := _Color;

  ChartSet.PaintBox.Canvas.MoveTo(5, _Y);
  ChartSet.PaintBox.Canvas.LineTo(Width + 10, _Y);
end;

end.
