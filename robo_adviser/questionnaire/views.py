from django.shortcuts import render

# Create your views here.

def start(request):
    return(render(request,'enter_questionnaire.html'))

def form1(request):
    return(render(request, "form1.html"))

def form2(request):
    return(render(request, "form2.html"))
