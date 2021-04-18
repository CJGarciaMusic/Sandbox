import atomac

app = atomac.getAppRefByBundleId("com.makemusic.Finale26")

menu_item = app.menuItem("Plug-ins", "JW Lua", "FJH Text Input").Press()

