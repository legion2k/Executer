unit uConst;

interface

const
  GRUOP_START     = 'Параметры_процесса';
  GRUOP_TERM      = 'Запустить_для_остановки';
  GRUOP_STOP      = 'Запустить_после_остановки';
  FIELD_CMD       = 'Программа_для_запуска';
  FIELD_PARAM     = 'Параметры_запуска';
  FIELD_PATH      = 'Рабочая_директория';
  FIELD_STDOUT    = 'Путь_к_файлу_стандартного_вывода';
  FIELD_STDERROR  = 'Путь_к_файлу_вывода_ошибок';
  FIELD_CNT       = 'Счетчик';
  //FIELD_ENABLE    = 'Запустить';
  GRUOP_ENV_START = 'Добавить_переменные_окружения_для_старта';
  GRUOP_ENV_TERM  = 'Добавить_переменные_окружения_для_останова';
  GRUOP_ENV_STOP  = 'Добавить_переменные_окружения_после_останова';


  EVENT_LOG_KEY = '\SYSTEM\CurrentControlSet\Services\Eventlog\Application\%s';

implementation

end.
