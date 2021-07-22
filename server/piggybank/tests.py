from django.test import TestCase
from django.urls import resolve
from piggybank.views import home_page


class HomePageTest(TestCase):
    def test_root_url_shows_spa_load_page(self):
        response = self.client.get("/")
        self.assertTemplateUsed(response, "index.html")
