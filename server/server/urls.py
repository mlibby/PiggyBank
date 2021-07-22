from django.conf.urls import url
from piggybank import views

urlpatterns = [
    url(r"^$", views.home_page, name="home")
]
