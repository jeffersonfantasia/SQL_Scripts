begin
if (pipeRelatorio['ESEMBALAGEMPRESENTE'] = 'S') then
  begin
    DBText18.Color := 65535;
    DBText18.Transparent := False;
  end
  else
  begin
    DBText18.Transparent := True;
  end;
end;