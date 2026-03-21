import json

class CharacterService:
    def __init__(self):
        self.data = {}

    def load(self):
        with open("assets/characters.json", encoding="utf-8") as f:
            self.data = json.load(f)

    def all(self):
        return list(self.data.keys())

    def get(self, name):
        return self.data.get(name, {})