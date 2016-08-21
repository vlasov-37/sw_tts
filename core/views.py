# -*- encoding: utf-8 -*-
from django.shortcuts import render
from core import forms


def index(request):
    c = {}
    form = forms.SynthForm(request.POST or None)
    if form.is_valid():
        pass
    c['form'] = form
    return render(request, 'core/index.html', c)