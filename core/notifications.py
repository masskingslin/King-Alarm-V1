import random

def schedule_daily_verse(service):
    try:
        from jnius import autoclass
        PythonActivity = autoclass('org.kivy.android.PythonActivity')
        Toast = autoclass('android.widget.Toast')

        verse = service.get("Psalms", 23, 1)

        Toast.makeText(
            PythonActivity.mActivity,
            verse["en"],
            Toast.LENGTH_LONG
        ).show()

    except:
        pass