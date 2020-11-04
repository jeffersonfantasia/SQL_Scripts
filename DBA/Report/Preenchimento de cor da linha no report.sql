Preenchimento de cor da linha no report

procedure DetailBeforePrint;
begin
  if (pipeRelatorio['ESEMBALAGEMPRESENTE'] = 'S') then
  begin
    Detail.Background1.Brush.Color  := 65535;
  end
  else
  begin
    Detail.Background1.Brush.Color  := 16777215;
  end;
end;