object fService: TfService
  OnCreate = ServiceCreate
  AllowPause = False
  DisplayName = 'Service'
  Interactive = True
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 325
  Width = 639
end
