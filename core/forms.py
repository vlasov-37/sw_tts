# encoding: utf-8
from django import forms
from django.contrib.auth.forms import AuthenticationForm
from django import forms
from django.utils.translation import ugettext_lazy as _

class CustomAuthenticationForm(AuthenticationForm):
    """
    Переопределяю класс чтобы добавить в input класс form-control
    """
    username = forms.CharField(
        max_length=254,
        widget = forms.TextInput(attrs={'class': 'form-control'})
    )

    password = forms.CharField(
        label=_("Password"),
        widget=forms.PasswordInput(attrs={'class': 'form-control'})
    )
class SynthForm(forms.Form):
    text = forms.CharField(
        label=u'Ваш текст',
        widget=forms.Textarea(
            attrs={'class': 'form-control', 'rows': 4, 'placeholder': u'Введите текст'}
        )
    )

