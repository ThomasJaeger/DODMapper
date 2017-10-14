object dm: Tdm
  OldCreateOrder = False
  Height = 508
  Width = 721
  object ftp: TIdFTP
    IPVersion = Id_IPv4
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 184
    Top = 61
  end
  object ActionManager1: TActionManager
    Left = 87
    Top = 61
    StyleName = 'Platform Default'
    object actExit: TAction
      Caption = 'E&xit'
      OnExecute = actExitExecute
    end
    object actSettings: TAction
      Caption = '&Settings'
      OnExecute = actSettingsExecute
    end
  end
end
