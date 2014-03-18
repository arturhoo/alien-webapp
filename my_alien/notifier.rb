module MyAlien

  class Notifier

    def self.enable()
      r = Alien::AlienReader.new
      r.open(MyAlien.reader_addr)

      r.automodereset
      r.autoaction       = 'acquire'
      r.autostarttrigger = '0 0'
      # r.autostoptimer    = '0'
      # r.autotruepause    = '0'
      # r.autofalsepause   = '0'

      r.notifyaddress    = "http://#{MyAlien.app_addr}:5000/api"
      r.notifytrigger    = 'add'
      r.notifytime       = '5'
      r.notifyformat     = 'text'
      r.notifymode       = 'on'
      # r.notifynow

      r.automode         = 'on'

      sleep(30)

      r.automode         = 'off'
      r.notifymode       = 'off'
      r.automodereset
      r.close
    end
  end
end
