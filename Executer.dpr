program Executer;

uses
  System.SysUtils,
  Winapi.Windows,
  System.JSON,
  Vcl.Forms,
  uFormMain in 'uFormMain.pas' {FormMain},
  uFileMapRecs in 'uFileMapRecs.pas',
  uTools in 'uTools.pas',
  Vcl.SvcMgr,
  uService in 'uService.pas' {fService: TService},
  uExecuter in 'uExecuter.pas',
  uExecTest in 'uExecTest.pas' {fTestExec: TFrame},
  uServiceEdit in 'uServiceEdit.pas' {fEditService},
  uServiceTools in 'uServiceTools.pas',
  uConst in 'uConst.pas',
  uServicesRule in 'uServicesRule.pas' {fServicesRule: TFrame},
  uImages in 'uImages.pas' {dmImages: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  uServiceProperty in 'uServiceProperty.pas' {FormProperty};

{$R *.res}

var
  gui: byte = 0;
  Name, DisplayName, ConfigFile, Login, Password, Dependence, Description: string;
begin
  if ParamCount() > 0 then
  begin
    if UpperCase(ParamStr(1))='-S' then
    begin
      gui := 0;
    end
    else
      gui := 2;
  end
  else
    gui := 1;

  case gui of
    1: //GUI
      begin
        Vcl.Forms.Application.Initialize;
        Vcl.Forms.Application.MainFormOnTaskbar := True;
        Vcl.Forms.Application.Title := 'EXEcuter - настройка и запуск';
        Vcl.Forms.Application.CreateForm(TdmImages, dmImages);
  Vcl.Forms.Application.CreateForm(TFormMain, FormMain);
        Vcl.Forms.Application.CreateForm(TfEditService, fEditService);
        Vcl.Forms.Application.CreateForm(TFormProperty, FormProperty);
        Vcl.Forms.Application.Run;
      end;
    0: //Service
      begin
        //if not Vcl.SvcMgr.Application.DelayInitialize or Vcl.SvcMgr.Application.Installing then
        Vcl.SvcMgr.Application.Initialize;
        Vcl.SvcMgr.Application.Title := 'EXEcuter - настройка и запуск';
        Vcl.SvcMgr.Application.CreateForm(TfService, fService);
        Vcl.SvcMgr.Application.Run;
      end;
    2: //Console Help
      begin
        //{$APPTYPE CONSOLE}
        if not AttachConsole(ATTACH_PARENT_PROCESS) then
          AllocConsole;
        if(UpperCase(ParamStr(1))='-I')and(ParamCount()>2)then
        begin
          var mng : TServiceManager;
          var cnt: Integer;
          cnt := ParamCount;
          Name        :=                           ParamStr(2).Trim;
          ConfigFile  :=                           ParamStr(3).Trim;
          DisplayName := tools.iff<string>( cnt>3, ParamStr(4).Trim, '' );
          Description := tools.iff<string>( cnt>4, ParamStr(5).Trim, '' );
          Login       := tools.iff<string>( cnt>5, ParamStr(6).Trim, '' );
          Password    := tools.iff<string>( cnt>6, ParamStr(7).Trim, '' );
          Dependence  := '';
          while cnt>7 do
          begin
            Dependence := Dependence + ParamStr(cnt) + #0;
            Dec(cnt)
          end;
          Dependence := Dependence + Tools.iff<string>( Dependence='', #0#0, #0 );
          try
            mng := TServiceManager.Create;
            mng.Add(ParamStr(0), Name, DisplayName, ConfigFile, Login, Password, Dependence, Description);
            mng.Free;
            Writeln('+ Cлужба '+Name+' установлена!');
          except
            on e: exception do
            begin
              Writeln('- При установки службы произошла ошибка:');
              Writeln('  ',e.Message);
            end;
          end;
        end
        else
        begin
          Writeln('');
          Writeln('--------------------------------------------------------------');
          Writeln('Executer.exe [key]');
          Writeln('   где key могут быть');
          Writeln('      <пусто>              - Запуск с GUI');
          Writeln('      -s "Имя Сервиса" ConfigFile.ini   - запуск сервиса');
          Writeln('      -i <params>          - установка сервиса');
          Writeln('           где <params> должны быть');
          Writeln('             "Имя сервиса"');
          Writeln('             "Полный путь к ConfigFile.ini"');
          Writeln('             "Отображаемое Имя"      - не обязательно (для пропуска введите " ")');
          Writeln('             "Описание"              - не обязательно (для пропуска введите " ")');
          Writeln('             "Логин"                 - не обязательно (для пропуска введите " ")');
          Writeln('             "Пароль"                - не обязательно (для пропуска введите " ")');
          Writeln('             "Запуск после службы 1" - не обязательно (для пропуска введите " ")');
          Writeln('             "Запуск после службы 2" - не обязательно (для пропуска введите " ")');
          Writeln('             "..."');
          Writeln('             "Запуск после службы n" - не обязательно');
          Writeln('--------------------------------------------------------------');
        end;
        //FreeConsole;
        exit();
      end;
  end;

end.
