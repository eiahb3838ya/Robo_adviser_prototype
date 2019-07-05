from django.shortcuts import render
from django.shortcuts import redirect
from django.urls import reverse
# Create your views here.
from django.http import HttpResponse


def showHomePage(request):
    # return HttpResponse("Hello, world. You're at the index.")
    return(render(request,'index.html'))

def goToRobot(request):
    try:
        user_email = request.GET['user_email']
    except:
        print("rrrrrr")

    #deal with the email
    print(user_email)

    return redirect(reverse('questionnaire:form1'))

