object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 383
  Top = 273
  Height = 248
  Width = 266
  object conn_SQL: TADOConnection
    LoginPrompt = False
    Left = 32
    Top = 40
  end
  object qy_SQL: TADOQuery
    Connection = conn_SQL
    Parameters = <>
    Left = 112
    Top = 40
  end
end
