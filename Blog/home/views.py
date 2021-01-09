from django.shortcuts import render, HttpResponse

# Create your views here.

def home(request):
	return HttpResponse("hello home")



def about(request):
	return HttpResponse("hello about")



def contact(request):
	return HttpResponse("hello contact")
