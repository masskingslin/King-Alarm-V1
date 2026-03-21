from kivy.app import App
from kivy.lang import Builder
from kivy.clock import Clock
from core.bible_service import BibleService
from core.notification import schedule_daily_verse

KV = Builder.load_file("ui/main.kv")

class BibleApp(App):
    def build(self):
        self.service = BibleService()
        Clock.schedule_once(self.load_default, 1)
        schedule_daily_verse(self.service)
        return KV

    def load_default(self, dt):
        verse = self.service.get("Genesis", 1, 1)
        self.root.ids.verse_label.text = verse["en"]

    def change_lang(self, lang):
        verse = self.service.get("Genesis", 1, 1)
        self.root.ids.verse_label.text = verse.get(lang, "N/A")

if __name__ == "__main__":
    BibleApp().run()