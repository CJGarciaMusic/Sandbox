import atomac

def click_left(note):
    '''
    mouse left click action
    '''
    position = note.AXPosition
    size = note.AXSize
    clickpoint = ((position[0] + size[0] / 2), (position[1] + size[1] / 2))
    try:
        note.clickMouseButtonLeft(clickpoint)
    except Exception as er:
        print("[-] Error @add_notes")
        print('[-] Error is '+str(er))


finale_app = atomac.getAppRefByLocalizedName("Finale")
finale_app.activate()
# print(finale_app.windows()[0].findAllR())
click_left(finale_app.windows()[0].findAllR(AXRole='AXMenuItem', AXRoleDescription='menu item', AXTitle='Aticulation'))

